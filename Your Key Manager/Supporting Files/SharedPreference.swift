//
//  sharedPreference.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 26/06/2018.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import Foundation

class SharedPreference {
    static let shared = SharedPreference()
    
    private init() {}
    
    func store(email: String) {
        UserDefaults.standard.setValue(email, forKey: "email")
    }
    
    func getStoredEmail() -> String? {
        return UserDefaults.standard.value(forKey: "email") as? String
    }
    
    func store(token: String) {
        UserDefaults.standard.setValue(token, forKey: "token")
    }
    
    func getToken() -> String {
        return UserDefaults.standard.value(forKey: "token") as! String
    }
    
    func saveTagIndicatingLoginIsStored() {
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
    }
    
    func hasLoginKeyStored() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasLoginKey")
    }

    func doesntHasLoginKeyStored() -> Bool {
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        return not(hasLoginKey)
    }
    
    func storeKeyIndicatingUserIsLoggedIn() {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func registerUserAuthenticationOnTouchID() {
        UserDefaults.standard.setValue(true, forKey: "TouchIDIsAuthenticated")
    }
    
    func userAlreadyAuthenticatedOnTouchID() -> Bool{
        let TouchIDIsAuthenticated = UserDefaults.standard.bool(forKey: "TouchIDIsAuthenticated")
        return TouchIDIsAuthenticated
    }
    
    func removeValue(fromKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
