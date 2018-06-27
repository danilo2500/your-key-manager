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
    private var userToken: String? = nil
    let apiManager = DevPeopleAPIManager()
    
    var userEmail: String! = nil
    var credentials: Variable<[WebsiteCredential]> = Variable([])
    
    func needsToAuthenticateTouchID() -> Bool {
        let userIsAutenticated = SharedPreference.shared.userAlreadyAuthenticatedOnTouchID()
        let haveTouchIDSupport = BiometricIDAuth.shared.isBiometricIDSupported()
        return not(userIsAutenticated) && haveTouchIDSupport
    }
    
    func fetchWebsiteCredentialsFromUser() -> [WebsiteCredential]? {
        let websiteCredentials = realmManager.getWebsiteCredentials(forUser: userEmail)
        return websiteCredentials
    }
    
    func fetchUserEmail() -> String! {
        return SharedPreference.shared.getStoredEmail()
    }
    
    func createUserOnDatabaseIfNeeded() {
        let containsUser = realmManager.containsUser(withEmail: userEmail)
        
        if not(containsUser) {
            let token = SharedPreference.shared.getToken()
            realmManager.createUser(email: userEmail, token: token)
        }
    }
    
    func getLogoImage(fromUrl url: String, completion: @escaping (UIImage?) -> Void ) {

        if self.userToken == nil {
            self.userToken = SharedPreference.shared.getToken()
        }
        
        apiManager.requestLogo(websiteUrl: url, token: userToken!) { (image, error) in
            completion(image)
        }
    }
}



































