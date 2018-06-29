//
//  ViewController.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 22/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SkyFloatingLabelTextField
import AMPopTip
import RxKeyboard

class LoginViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!

    @IBOutlet weak var networkActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var biometryButton: UIButton!
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    let popTip = PopTip()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopUp()
        setupReactiveBinds()
        setupSignInButton()
        setupRegisterButton()
        setupEmailFieldField()
        setupPasswordTextField()
        setupBiometricBarItem()
        setupNetworkReactiveBinds()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupPopUp() {
        popTip.textAlignment = .left
    }
    
    func setupNetworkReactiveBinds() {
        viewModel.isLoginIn.asObservable().bind(to: networkActivityIndicator.rx.isAnimating).disposed(by: disposeBag)
        viewModel.isLoginIn.asObservable().subscribe(onNext: { [unowned self] isLoginIn in
            let title = isLoginIn ? "" : "Entrar"
            DispatchQueue.main.async {
                self.emailTextField.isEnabled = not(isLoginIn)
                self.passwordTextField.isEnabled = not(isLoginIn)
                self.signInButton.setTitle(title, for: .normal)
            }

        }).disposed(by: disposeBag)
    }
    
    func setupReactiveBinds() {
        
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.canLoginIn.bind(to: signInButton.rx.isEnabled).disposed(by: disposeBag)
        
    }
    
    func setupSignInButton() {
        viewModel.canLoginIn
            .throttle(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (credentialsAreValid) in
            DispatchQueue.main.async {
                self.signInButton.isEnabled = credentialsAreValid
                self.popTip.hide()
                self.signInButton.alpha = credentialsAreValid ? 1.0 : 0.5
            }
        }).disposed(by: disposeBag)
        
        signInButton.rx.tap.bind{ [unowned self] in
            let email = self.emailTextField.text!
            let password = self.passwordTextField.text!
            self.signIn(email: email, password: password)
            }.disposed(by: disposeBag)
    }
    
    func signIn(email: String, password: String) {
        if not(Connectivity.isConnectedToInternet()) {
            self.showNoInternetConnectionError()
            return
        }

        self.viewModel.signIn(email: email, password: password, completion: { [unowned self] (user, errorDescription) in
            if user != nil{
                self.showHomeScreen()
            }
            if let errorDescription = errorDescription{
                self.showErrorFeedback(errorDescription)
            }
        })
    }
    
    func showNoInternetConnectionError() {
        let tip = "Verifique sua conexão com a internet"
        showPopUpTip(tip, inView: signInButton)
    }
    
    func showErrorFeedback(_ errorDescription: String) {
        showPopUpTip(errorDescription, inView: signInButton)

    }
    
    func showHomeScreen() {
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeNavigationController")
        show(homeViewController, sender: nil)
    }
    
    func setupRegisterButton() {
        registerButton.rx.tap.bind{ [unowned self] in
            self.showRegisterScreen()
            }.disposed(by: disposeBag)
    }
    
    func showRegisterScreen() {
        let registerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerViewController")
        navigationController!.pushViewController(registerViewController, animated: true)
    }
    
    func setupEmailFieldField() {
        
        if let email = viewModel.getEmailUsedOnLastLogin() {
            emailTextField.text = email
            emailTextField.sendActions(for: .valueChanged)
        }
        
        emailTextField.rx.controlEvent(.editingDidEnd)
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                guard let email = self.emailTextField.text else { return }
                if not(Util.isValid(email: email)){
                    self.showEmailValidationInformation()
                }
                
            }).disposed(by: disposeBag)
    }
    
    func showEmailValidationInformation() {
        let tip = emailTextField.text!.isEmpty ? "E-mail precisa ser prenchido" : "E-mail incorreto"
        showPopUpTip(tip, inView: emailTextField)
    }
    
    func setupPasswordTextField() {
        
        passwordTextField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                guard let password = self.passwordTextField.text else { return }
                if not(Util.isValid(password: password)){
                    self.showPasswordValidationInformation()
                }
            }).disposed(by: disposeBag)
    }
    
    func showPasswordValidationInformation() {
        let tip = "Senha precisa conter:\n8 caracteres;\nUm número;\nUma letra maiúscula;\nUma letra minúscula;\nUm caractere especial."
        showPopUpTip(tip, inView: passwordTextField)
    }

    func setupBiometricBarItem() {
        
        biometryButton.isHidden = viewModel.shouldHideBiometryOptions()
        
        biometryButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.displayBiometryAuth()
        }).disposed(by: disposeBag)
    }
    
    func displayBiometryAuth() {
        let touchIDReason = "Utilize sua biometria para realizar seu login"
        let biometricIDAuth = BiometricIDAuth()
        biometricIDAuth.authenticateUser(touchIDReason: touchIDReason){ [unowned self] (sucess, error) in
            if sucess {
                let email = SharedPreference.shared.getStoredEmail()!
                let password = KeychainManager.shared.getUserPassword(email: email)!
                self.signIn(email: email, password: password)
            }
            if let error = error {
                print(biometricIDAuth.getTouchIDErrorMessage(error))
            }
        }
    }
    
    func showPopUpTip(_ tip: String, inView view: UIView) {
        let superView = view.superview!
        popTip.show(text: tip, direction: .up, maxWidth: 220, in: superView, from: view.frame)
    }
    
//    func setupKeyboard() {
//        RxKeyboard.instance.frame.asObservable().subscribe(onNext: { [unowned self] (keyboardFrame) in
//            let textFieldPosition = self.passwordTextField.convert(self.passwordTextField.bounds, to: self.view)
//            if keyboardFrame.intersects(textFieldPosition) {
//                self.contentAreaStackView.frame.origin.y = self.view.frame.height - self.contentAreaStackView.frame.height - keyboardFrame.height
//            }
//        }).disposed(by: disposeBag)
//    }
    
}

























