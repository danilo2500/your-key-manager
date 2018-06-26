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
    private let realmManager = RealmManager.shared
    
    let apiManager = DevPeopleAPIManager()
    
    var userEmail: String! = nil
    var credentials: Variable<[WebsiteCredential]> = Variable([])
    
    func needsToAuthenticateTouchID() -> Bool {
        let userIsAutenticated = BiometricIDAuth.shared.userAlreadyAuthenticated()
        let haveTouchIDSupport = BiometricIDAuth.shared.isBiometricIDSupported()
        return not(userIsAutenticated) && haveTouchIDSupport
    }
    
    func fetchWebsiteCredentialsFromUser() -> [WebsiteCredential]? {
        let websiteCredentials = realmManager.getWebsiteCredentials(forUser: userEmail)
        return websiteCredentials
    }
    
    func fetchUserEmail() -> String! {
        return KeychainManager.shared.getStoredEmail()
    }
    
    func createUserOnDatabaseIfNeeded() {
        let containsUser = realmManager.containsUser(withEmail: userEmail)
        
        if not(containsUser) {
            realmManager.createUser(email: userEmail)
        }
    }
    
    func getLogoImage(fromUrl url: String) {
        apiManager.requestLogo(websiteURL: url, token: <#T##String#>) { (image, errorDescription) in
            <#code#>
        }
    }
}



































