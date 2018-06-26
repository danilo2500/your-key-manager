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

class HomeViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var logOutBarButton: UIBarButtonItem!
    
    @IBOutlet weak var credentialsTableView: UITableView!
    
    
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    let apiManagerLocal = DevPeopleAPIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupLogOutButton()
        setupTableView()
        
        viewModel.userEmail = viewModel.fetchUserEmail()
        viewModel.createUserOnDatabaseIfNeeded()
        showUserCredentials()

        authenticateTouchIDIfNeeded()
    }
    
    func authenticateTouchIDIfNeeded() {
        if viewModel.needsToAuthenticateTouchID(){
            registerBiometricAuth()
        }
    }
    
    @IBAction func adicionar(_ sender: Any) {
        RealmManager.shared.addWebCredentialsForCurrentUserForTesting()
    }
    
    func setupLogOutButton() {
        
        
        logOutBarButton.rx.tap.bind { [unowned self] in
            let loginNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginNavigationController")
            self.show(loginNavigationController, sender: nil)
            }.disposed(by: disposeBag)
        
    }
    
    func setupTableView() {

        credentialsTableView.rx.setDelegate(self).disposed(by: disposeBag)





        viewModel.credentials.asObservable()
            .bind(to: credentialsTableView.rx.items(cellIdentifier: "credentialCell", cellType: CredentialTableViewCell.self)) { [weak self] (row, websiteCredential, cell) in
                cell.emailTextField.text =  websiteCredential.email
                cell.nameLabel.text = websiteCredential.name
                let URL = websiteCredential.url
                self!.viewModel.getLogoImage(fromUrl: URL , completion: { (image) in
                    
                    cell.logoImageView.image = image

                })


            }
            .disposed(by: disposeBag)
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
    
}















