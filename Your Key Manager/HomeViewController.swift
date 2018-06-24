//
//  HomeViewController.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 23/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        registerBiometricAuth()
        
        showUserCredentials()
        
    }
    
    func registerBiometricAuth(){
        BiometricIDAuth.shared.authenticateUser { (sucess, error) in
            if sucess{
                print("TOUCH ID CADASTRADO")
            }
        }
    }
    
    func showUserCredentials() {
        let credentials = viewModel.getWebsiteCredentials()

    }

    
}
