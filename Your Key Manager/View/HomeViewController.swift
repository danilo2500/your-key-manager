//
//  HomeViewController.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 23/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logOutBarButton: UIBarButtonItem!
    
    @IBOutlet weak var credentialsTableView: UITableView!
    
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    let apiManagerLocal = DevPeopleAPIManager()
    
    @IBAction func addNewCredential(_ sender: Any) {
        showSaveCredentialViewController()
    }
    
    @IBAction func logOut(_ sender: Any) {
        showLoginViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupReactiveBinds()

        
        viewModel.userEmail = viewModel.fetchUserEmail()
        viewModel.createUserOnDatabaseIfNeeded()

        authenticateTouchIDIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showUserCredentials()
    }
    
    func authenticateTouchIDIfNeeded() {
        if viewModel.needsToAuthenticateTouchID(){
            registerBiometricAuth()
        }
    }
    
    func setupTableView() {
        credentialsTableView.tableFooterView = UIView(frame: .zero)
    }
    
    func setupReactiveBinds() {
        viewModel.credentials.asObservable().subscribe { [unowned self] (website) in
            
            self.credentialsTableView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    
    func registerBiometricAuth(){
        let touchIDReason = "Confirme sua biometria para utilizar TouchID na próxima vez que fizer login"
        BiometricIDAuth.shared.authenticateUser(touchIDReason: touchIDReason) { (sucess, error) in
            if sucess{
                print("TOUCH ID CADASTRADO, Agora vc pode logar usando o touch ID")
            }
            if let error = error {
                print(error)
            }
        }
    }
    
    func showUserCredentials() {
        if let credentials = viewModel.fetchWebsiteCredentialsFromUser() {
            viewModel.credentials.value = credentials
        }else{
            showFeedbackWithNoCredentials()
        }
    }
    
    func showFeedbackWithNoCredentials() {
        print("usuario nao tem credenciais salvas")
    }
    
    
    func showLoginViewController() {
        let loginNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNavigationController")
        self.show(loginNavigationController, sender: nil)
    }
    
    func showSaveCredentialViewController() {
        let saveCredentialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "saveCredentialViewController")
        navigationController?.pushViewController(saveCredentialViewController, animated: true)
    }
    
    func showSaveCredentialViewControllerWith(webCredential: WebsiteCredential) {
        let saveCredentialViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "saveCredentialViewController") as! SaveCredentialViewController
        
        saveCredentialViewController.URLTextField.text = webCredential.url
        //saveCredentialViewController.URLTextField.sendActions(for: .editingDidEnd)
        saveCredentialViewController.nameTextField.text = webCredential.name
        //saveCredentialViewController.nameTextField.sendActions(for: .editingDidEnd)
        saveCredentialViewController.emailTextField.text = webCredential.email
        //saveCredentialViewController.emailTextField.sendActions(for: .editingDidEnd)
        
        navigationController!.pushViewController(saveCredentialViewController, animated: true)
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.credentials.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "credentialCell", for: indexPath) as! CredentialTableViewCell
        
        let websiteCredential = viewModel.credentials.value[indexPath.row]
        cell.emailTextField.text =  websiteCredential.email
        cell.nameLabel.text = websiteCredential.name
        let url = websiteCredential.url
        cell.logoImageView.image = nil
        self.viewModel.getLogoImage(fromUrl: url , completion: { (image) in
            cell.logoImageView.image = image
            cell.imageActivityIndicator.stopAnimating()
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webCredential = viewModel.credentials.value[indexPath.row]
        showSaveCredentialViewControllerWith(webCredential: webCredential)
    }
}













