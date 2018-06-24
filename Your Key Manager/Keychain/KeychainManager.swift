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
    
    private init(){}
    
    func saveLoginCredentials(email: String, password: String){
        
        if doesntHasLoginKeyStored() {
            storeEmailOnUserDefaults(email)
        }
        
        storePasswordOnKeychain(email: email, password: password)
        
        saveTagIndicatingLoginIsStored()
        
    }
    
//    func checkIfLoginIsCorrect(email: String, password: String) -> Bool {
//        guard email == UserDefaults.standard.value(forKey: "email") as? String else {
//            return false
//        }
//
//        do {
//            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
//                                                    account: email,
//                                                    accessGroup: KeychainConfiguration.accessGroup)
//            let keychainPassword = try passwordItem.readPassword()
//            return password == keychainPassword
//        } catch {
//            fatalError("Error reading password from keychain - \(error)")
//        }
//    }
    
    func getUserPasswordStoredOnKeychain() -> String? {
        
        guard let email = getStoredEmail() else {
            fatalError("No email stored")
        }
        
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
    
    func getStoredEmail() -> String? {
        let email = UserDefaults.standard.value(forKey: "email") as? String
        return email
    }
    
    func hasLoginKeyStored() -> Bool {
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        return hasLoginKey
    }
    
    private func doesntHasLoginKeyStored() -> Bool {
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        return not(hasLoginKey)
    }
    
    func storeWebsitePassword( websiteURL: String, password: String) {
        
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: websiteURL,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            try passwordItem.savePassword(password)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    func getWebsitePassword( websiteURL: String) -> String? {
    
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: websiteURL,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return keychainPassword
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
    }
    
    private func storeEmailOnUserDefaults(_ email: String){
        UserDefaults.standard.setValue(email, forKey: "email")
    }
    
    private func storePasswordOnKeychain(email: String, password: String) {
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: email,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            try passwordItem.savePassword(password)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    private func saveTagIndicatingLoginIsStored(){
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
    }
    
}
