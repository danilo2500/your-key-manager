//
//  RegisterViewController.swift
//
//
//  Created by Danilo Henrique on 23/06/18.
//

import UIKit
import RxSwift

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    let viewModel = RegisterViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReactiveBinds()
        setupCreateAccountButton()
        setupEmailFieldField()
        setupPasswordTextField()
        
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
        
        viewModel.AllCredentialsAreValid.bind(to: createAccountButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func setupCreateAccountButton(){
        viewModel.AllCredentialsAreValid.subscribe(onNext: { [unowned self] (credentialsAreValid) in
            self.createAccountButton.isEnabled = credentialsAreValid
        }).disposed(by: disposeBag)
        
        createAccountButton.rx.tap.bind{ [unowned self] in
            
            if not(Connectivity.isConnectedToInternet()) {
                self.showNoInternetConnectionError()
                return
            }
            let email = self.emailTextField.text!
            let password = self.passwordTextField.text!
            let name = self.nameTextField.text!
            
            self.viewModel.createUser(email: email, password: password, name: name, completion: { [unowned self] (user, error) in
                
                if user != nil {
                    self.showHomeScreen()
                }
                if let error = error {
                    self.showErrorFeedback(error)
                }
            })
            }.disposed(by: disposeBag)
    }
    
    func showNoInternetConnectionError() {
        print("Vc esta sem internet")
    }
    
    func showHomeScreen(){
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeNavigationController")
        show(homeViewController, sender: nil)
    }
    
    func showErrorFeedback(_ error: Error){
        let errorDescription = viewModel.getErrorDescription(error)
        print(errorDescription)
    }
    
    func setupEmailFieldField(){
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
    
    func showEmailValidationInformation(){
        print("formato de email incorreto")
    }
    
    func dismissEmailValidationInformation(){
        print("vc escreveu o email correto")
    }
    
    func setupPasswordTextField(){
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
    
    func showPasswordValidationInformation(){
        print("A senha deverá conter no mínimo 8 caracteres, dos quais deve possuir no mínimo 1 letra, 1 número e 1 caractere especial")
    }
    func dismissPasswordValidationInformation(){
        print("vc escreveu a senha correto")
    }
}












































