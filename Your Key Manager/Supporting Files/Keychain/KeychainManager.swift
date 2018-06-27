//
//  KeychainManager.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 24/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import Foundation

class KeychainManager {
    static let shared = KeychainManager()
    private let sharedPreference = SharedPreference.shared
    
    private init(){}
    
    func storeUserPassword(email: String, password: String){
        storeUserPasswordOnKeychain(email: email, password: password)
        sharedPreference.saveTagIndicatingLoginIsStored()
    }
    
    func getUserPassword(email: String) -> String? {

        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: email,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return keychainPassword
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
    }
    
    private func storeUserPasswordOnKeychain(email: String, password: String) {
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: email,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            try passwordItem.savePassword(password)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    func storeWebsitePassword(userEmail: String, websiteURL: String, password: String) {
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: userEmail + websiteURL,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            try passwordItem.savePassword(password)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    func getWebsitePassword(userEmail: String, websiteURL: String) -> String? {
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: userEmail + websiteURL,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return keychainPassword
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
    }
    

}

