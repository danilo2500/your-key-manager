//
//  HomeViewController.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 23/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //let biometricAuth = BiometricAuthenticator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        registerBiometricAuth()
        
    }
    
    func registerBiometricAuth(){
        BiometricIDAuth.shared.authenticateUser { (sucess, error) in
            if sucess{
                print("TOUCH ID CADASTRADO")
            }
            if let error = error{
                print(BiometricIDAuth.shared.getTouchIDErrorMessage(error))
            }

        }
    }
    
    func validateUserBiometry(){
        
    }
    
    func showErrorValidatingBiometry(){
        print("erro ao adicinar biometria")
    }
    
}
