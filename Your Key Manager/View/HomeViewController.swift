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
import AMPopTip

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logOutBarButton: UIBarButtonItem!
    @IBOutlet weak var noCredentialsFeedbackView: UIView!
    @IBOutlet weak var addCredentialBarButton: UIBarButtonItem!
    
    
    @IBOutlet weak var credentialsTableView: UITableView!
    
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    let popTip = PopTip()
    
    let apiManagerLocal = DevPeopleAPIManager()
    
    @IBAction func addNewCredential(_ sender: Any) {
        showSaveCredentialViewController()
    }
    
    @IBAction func logOut(_ sender: Any) {
        showLogOutAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupReactiveBinds()
        
        viewModel.userEmail = viewModel.fetchUserEmail()
        viewModel.createUserOnDatabaseIfNeeded()
        setupNoCredentialsFeedback()
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
        let biometricIDAuth = BiometricIDAuth()
        biometricIDAuth.authenticateUser(touchIDReason: touchIDReason) { (sucess, error) in
            if sucess{
                SharedPreference.shared.registerUserAuthenticationOnTouchID()
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
    
    func showLoginViewController() {
        let loginNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNavigationController")
        self.show(loginNavigationController, sender: nil)
    }
    
    func showSaveCredentialViewController() {
        let saveCredentialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "saveCredentialViewController") as! SaveCredentialViewController
        saveCredentialViewController.viewModel.saveCredentialTask = .saving
        navigationController?.pushViewController(saveCredentialViewController, animated: true)
    }
    
    func showSaveCredentialViewControllerWith(webCredential: WebsiteCredential) {
        let saveCredentialViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "saveCredentialViewController") as! SaveCredentialViewController

        saveCredentialViewController.viewModel.updatedWebCredential = webCredential
        saveCredentialViewController.viewModel.saveCredentialTask = .updating
        
        navigationController!.pushViewController(saveCredentialViewController, animated: true)
    }
    
    func setupNoCredentialsFeedback() {
        viewModel.credentials.asObservable().subscribe(onNext: { [unowned self] webCredentials in
            if webCredentials.isEmpty {
                self.showFeedbackWithNoCredentials()
            }else{
                self.dismissFeedbackWithNoCredentials()
            }
        }).disposed(by: disposeBag)
    }
    
    func showFeedbackWithNoCredentials() {
        noCredentialsFeedbackView.isHidden = false
    }
    
    func dismissFeedbackWithNoCredentials() {
        noCredentialsFeedbackView.isHidden = true
        popTip.hide()
    }
    
    func showLogOutAlert() {
        let alertController = UIAlertController(title: "Sair", message: "Tem certeza que deseja sair da sua conta?", preferredStyle: .alert)
        
        let acceptButton = UIAlertAction(title: "Sim", style: .default) { [unowned self] _ in
            self.showLoginViewController()
        }
        let cancelButton = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(acceptButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let webCredential = viewModel.credentials.value[indexPath.row]
            viewModel.removeWebcredentialFromDatabase(webCredential)
            viewModel.credentials.value.remove(at: indexPath.row)
        }
    }
}













