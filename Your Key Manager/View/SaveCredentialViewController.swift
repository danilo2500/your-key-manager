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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReactiveBinds()
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
        
        nameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        URLTextField.rx.text
            .orEmpty
            .bind(to: viewModel.URL)
            .disposed(by: disposeBag)
        
        viewModel.canSaveCredential
            .throttle(0.1, scheduler: MainScheduler.instance)
            .bind(to: saveBarButton.rx.isEnabled).disposed(by: disposeBag)
    }
}
