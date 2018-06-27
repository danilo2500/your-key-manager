//
//  HomeViewModel.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 24/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//


import Foundation
import RxSwift
import Kingfisher
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
        
        if let cachedImage = retrieveImageOnCache(url: url) {
            completion(cachedImage)
            return
        }
        
        if self.userToken == nil {
            self.userToken = SharedPreference.shared.getToken()
        }
        
        apiManager.requestLogo(websiteUrl: url, token: userToken!) { [unowned self] (image, error) in
            if let image = image{
                self.storeImageOnCache(image: image, url: url)
            }
            completion(image)
        }
    }
    
    private func retrieveImageOnCache(url: String) -> UIImage? {
        let imageCache = ImageCache(name: "imageCache")
        let image = imageCache.retrieveImageInDiskCache(forKey: url)
        return image
    }
    
    private func storeImageOnCache(image: UIImage, url: String) {
        let imageCache = ImageCache(name: "imageCache")
        imageCache.store(image, forKey: url)
    }
    
    func removeWebcredentialFromDatabase(_ webcredential: WebsiteCredential){
        KeychainManager.shared.removeWebsitePassword(credentialID: webcredential.id)
        RealmManager.shared.deleteFromDatabase(webcredential)
    }
}



































