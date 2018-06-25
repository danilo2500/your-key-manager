//
//  HomeViewModel.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 24/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//


import Foundation
import RxSwift
import Moya

class HomeViewModel {
    
    func needsToAuthenticateTouchID() -> Bool {
        let userIsAutenticated = BiometricIDAuth.shared.userAlreadyAuthenticated()
        let haveTouchIDSupport = BiometricIDAuth.shared.isBiometricIDSupported()
        return not(userIsAutenticated) && haveTouchIDSupport
    }
    
    func getWebsiteCredentials() {
        
    }
}



































