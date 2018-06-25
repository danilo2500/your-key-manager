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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var biometryBarItem: UIBarButtonItem!
    
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReactiveBinds()
        setupSignInButton()
        setupRegisterButton()
        setupEmailFieldField()
        setupPasswordTextField()
        setupBiometricBarItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBiometricBarItem()
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
        
        viewModel.AllCredentialsAreValid.bind(to: signInButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func setupSignInButton() {
        viewModel.AllCredentialsAreValid.subscribe(onNext: { [unowned self] (credentialsAreValid) in
            self.signInButton.isEnabled = credentialsAreValid
        }).disposed(by: disposeBag)
        
        signInButton.rx.tap.bind{ [unowned self] in
            
            if not(Connectivity.isConnectedToInternet()) {
                self.showNoInternetConnectionError()
                return
            }
            
            self.viewModel.signIn(completion: { [unowned self] (user, error) in
                if let user = user{
                    self.showHomeScreen()
                }
                if let error = error{
                    self.showErrorFeedback(error)
                }
            })
        }.disposed(by: disposeBag)
    }
    
    func showNoInternetConnectionError() {
        print("Vc esta sem internet")
    }
    
    func showErrorFeedback(_ error: Error) {
        let errorDescription = viewModel.getErrorDescription(error)
        print(errorDescription)
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
        emailTextField.rx.controlEvent(.editingDidEnd)
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                guard let email = self.emailTextField.text else { return }
                if self.viewModel.isValidEmail(email: email){
                    self.dismissEmailValidationInformation()
                }else{
                    self.showEmailValidationInformation()
                }
                
            }).disposed(by: disposeBag)
    }
    
    func showEmailValidationInformation() {
        print("formato de email incorreto")
    }
    
    func dismissEmailValidationInformation() {
        print("vc escreveu o email correto")
    }
    
    func setupPasswordTextField() {
        passwordTextField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                guard let password = self.passwordTextField.text else { return }
                if self.viewModel.isValidPassword(password: password){
                     self.dismissPasswordValidationInformation()
                }else{
                    self.showPasswordValidationInformation()
                }
            }).disposed(by: disposeBag)
    }
    
    func showPasswordValidationInformation() {
        print("A senha deverá conter no mínimo 8 caracteres, dos quais deve possuir no mínimo 1 letra, 1 número e 1 caractere especial")
    }
    func dismissPasswordValidationInformation() {
        print("vc escreveu a senha correto")
    }
    
    func setupBiometricBarItem() {
    
        if KeychainManager.shared.hasLoginKeyStored() && BiometricIDAuth.shared.isBiometricIDSupported(){
            biometryBarItem.isEnabled = true
        }else{
            biometryBarItem.isEnabled = false
        }
        
        biometryBarItem.rx.tap.bind{ [unowned self] in
            self.displayBiometryAuth()
        }.disposed(by: disposeBag)
    }
    
    func displayBiometryAuth() {
        BiometricIDAuth.shared.authenticateUser { [unowned self] (sucess, error) in
            if sucess {
                self.loginAutomaticallyUsingEmailOnKeychain()
            }
            if let error = error {
                print(BiometricIDAuth.shared.getTouchIDErrorMessage(error))
            }
        }
    }
    
    func loginAutomaticallyUsingEmailOnKeychain() {
        guard let password = KeychainManager.shared.getUserPassword(), let email = KeychainManager.shared.getStoredEmail() else {
            fatalError("No password or email saved correctly")
        }
        emailTextField.text = email
        passwordTextField.text = password
        self.viewModel.signIn(completion: { [unowned self] (user, error) in
            if let user = user{
                self.showHomeScreen()
            }
            if let error = error{
                self.showErrorFeedback(error)
            }
        })
        
    }
    
    
}































