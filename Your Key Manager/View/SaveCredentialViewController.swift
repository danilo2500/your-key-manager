//
//  SaveCredentialViewController.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 26/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import UIKit
import RxSwift

class SaveCredentialViewController: UIViewController {
    
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var showHidePasswordButton: UIButton!
    
    let viewModel = SaveCredentialViewModel()
    let disposeBag = DisposeBag()
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let email = emailTextField.text!
        let name = nameTextField.text!
        let password = passwordTextField.text!
        let url = URLTextField.text!
        viewModel.saveOrUpdateWebCredentialOnDatabase(email: email, url: url, name: name, password: password)
        
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func showOrHidePassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        let title = passwordTextField.isSecureTextEntry ? "Mostrar Senha" : "Ocultar Senha"
        showHidePasswordButton.setTitle(title, for: .normal)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReactiveBinds()
        setupTextFieldsWithValuesIfNeeded()
        setupNavigationTitle()
    }
    
    func setupNavigationTitle() {
        if viewModel.saveCredentialTask == .saving{
            title = "Adicionar"
        }
        if viewModel.saveCredentialTask == .updating{
            title = "Editar"
        }
    }
    
    func setupReactiveBinds() {
        
        emailTextField.rx.text
            .map{[unowned self] email in
                return email!.isEmpty ? self.viewModel.email.value : email!
            }
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
    
        nameTextField.rx.text
            .map{[unowned self] name in
                return name!.isEmpty ? self.viewModel.name.value : name!
            }
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        URLTextField.rx.text
            .map{[unowned self] url in
            return url!.isEmpty ? self.viewModel.URL.value : url!
            }
            .bind(to: viewModel.URL)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .map{[unowned self] password in
                return password!.isEmpty ? self.viewModel.password.value : password!
            }
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.canSaveCredential
            .throttle(0.1, scheduler: MainScheduler.instance)
            .bind(to: saveBarButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func setupTextFieldsWithValuesIfNeeded() {
        emailTextField.text = viewModel.email.value
        passwordTextField.text = viewModel.password.value
        nameTextField.text = viewModel.name.value
        URLTextField.text = viewModel.URL.value
        
        
    }
}
