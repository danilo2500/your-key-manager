//
//  RegisterViewController.swift
//
//
//  Created by Danilo Henrique on 23/06/18.
//

import UIKit
import AMPopTip
import RxSwift
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var networkActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    let viewModel = RegisterViewModel()
    let disposeBag = DisposeBag()
    let popTip = PopTip()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReactiveBinds()
        setupCreateAccountButton()
        setupEmailFieldField()
        setupPasswordTextField()
        setupPopUp()
        setupActivityIndicator()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupActivityIndicator() {
        viewModel.isCreatingUser.asObservable().bind(to: networkActivityIndicator.rx.isAnimating).disposed(by: disposeBag)
        viewModel.isCreatingUser.asObservable().subscribe(onNext: { [unowned self] isCreatingAccount in
            let title = isCreatingAccount ? "" : "Criar nova conta"
            self.createAccountButton.setTitle(title, for: .normal)
        }).disposed(by: disposeBag)
    }
    
    func setupPopUp() {
        popTip.textAlignment = .left
    }
    
    func setupReactiveBinds(){
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        nameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        viewModel.canCreateUser.bind(to: createAccountButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func setupCreateAccountButton(){
        viewModel.canCreateUser
            .throttle(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (credentialsAreValid) in
                self.createAccountButton.isEnabled = credentialsAreValid
                self.createAccountButton.alpha = credentialsAreValid ? 1.0 : 0.5
        }).disposed(by: disposeBag)
        
        createAccountButton.rx.tap.bind{ [unowned self] in
            self.createAccount()
            }.disposed(by: disposeBag)
    }
    
    func createAccount() {
        if not(Connectivity.isConnectedToInternet()) {
            self.showNoInternetConnectionError()
            return
        }
        createAccountButton.setTitle("", for: .disabled)
        networkActivityIndicator.startAnimating()
        
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        let name = self.nameTextField.text!
        
        self.viewModel.createUser(email: email, password: password, name: name, completion: { [unowned self] (user, errorDescription) in
            self.createAccountButton.setTitle("", for: .disabled)
            self.networkActivityIndicator.stopAnimating()
            if user != nil {
                self.showHomeScreen()
            }
            if let errorDescription = errorDescription {
                self.showErrorFeedback(errorDescription)
            }
        })
        
    }
    
    func showNoInternetConnectionError() {
        popTip.show(text: "Verifique sua conexão com a internet", direction: .up, maxWidth: 220, in: view, from: createAccountButton.frame)
    }
    
    func showHomeScreen(){
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeNavigationController")
        show(homeViewController, sender: nil)
    }
    
    func showErrorFeedback(_ errorDescription: String){
        popTip.show(text: errorDescription, direction: .up, maxWidth: 220, in: view, from: createAccountButton.frame)
    }
    
    func setupEmailFieldField(){
        emailTextField.rx.controlEvent(.editingDidEnd)
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                guard let email = self.emailTextField.text else { return }
                if not(Util.isValid(email: email)){
                    self.showEmailValidationInformation()
                }
                
            }).disposed(by: disposeBag)
    }
    
    func showEmailValidationInformation(){
        let tip = emailTextField.text!.isEmpty ? "E-mail precisa ser prenchido" : "E-mail incorreto"
        popTip.show(text: tip, direction: .up, maxWidth: 220, in: view, from: emailTextField.frame)
    }
    
    func setupPasswordTextField(){
        passwordTextField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [unowned self] in
                guard let password = self.passwordTextField.text else { return }
                if not(Util.isValid(password: password)){
                    self.showPasswordValidationInformation()
                }
            }).disposed(by: disposeBag)
    }
    
    func showPasswordValidationInformation(){
        let tip = "Senha precisa conter no mínimo 8 caracteres, conter um número, uma letra maiúscula, uma letra minúscula e um caractere especial"
        popTip.show(text: tip, direction: .up, maxWidth: 220, in: view, from: passwordTextField.frame)
    }
}












































