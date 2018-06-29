//
//  SaveCredentialViewController.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 26/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import UIKit
import RxSwift
import AMPopTip


class SaveCredentialViewController: UIViewController {
    
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var showHidePasswordButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    
    
    let viewModel = SaveCredentialViewModel()
    let disposeBag = DisposeBag()
    let popTip = PopTip()
    
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
        setupCopyButton()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    func setupCopyButton() {
        passwordTextField.rx.text.asObservable().subscribe(onNext: { [unowned self] (password) in
            if password!.isEmpty {
                self.dismissCopyButton()
            } else {
                self.showCopyButton()
            }
        }).disposed(by: disposeBag)
        
        copyButton.rx.tap.bind{ [unowned self] in
            let password = self.passwordTextField.text!
            self.viewModel.copyToClipboard(text: password)
            self.showPopUpTip("Senha copiada para área de transferencia", inView: self.passwordTextField)
            }.disposed(by: disposeBag)
    }
    
    func showCopyButton() {
        self.copyButton.isHidden = false
    }
    
    func dismissCopyButton() {
        self.copyButton.isHidden = true
    }
    
    func showPopUpTip(_ tip: String, inView view: UIView) {
        let superView = view.superview!
        popTip.bubbleColor = .white
        popTip.textColor = .black
        popTip.show(text: tip, direction: .up, maxWidth: 200, in: superView, from: view.frame)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
            self.popTip.hide()
        }
    }
    
}
