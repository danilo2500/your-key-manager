//
//  HomeViewController.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 23/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import UIKit
import BiometricAuthenticator

class HomeViewController: UIViewController {

    //let biometricAuth = BiometricAuthenticator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if biometricAuth.isTouchIdEnabledOnDevice() {
            registerBiometricAuth()
        //}
        
    }
    
    func registerBiometricAuth(){
//        biometricAuth.authenticateWithBiometrics(localizedReason: "ENFIA O DEDO", successBlock: { [unowned self] in
//            self.validateUserBiometry()
//        }, failureBlock: { (error) in
//            self.showErrorValidatingBiometry()
//        })
    }
    
    func validateUserBiometry(){
        
    }
    
    func showErrorValidatingBiometry(){
        print("erro ao adicinar biometria")
    }
    
}
