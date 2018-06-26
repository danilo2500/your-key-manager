//
//  RealmManager.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 24/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

    func getWebsiteCredentials(forUser email: String) -> [WebsiteCredential]? {
        guard let user = getUser(withEmail: email) else{
            return nil
        }
        return Array(user.websiteCredentials)
    }

    func getAllUsersForDebug() -> [Person] {
        let results = realm.objects(Person.self)
        return Array(results)
    }
    
    func containsUser(withEmail email: String) -> Bool {
        let user = getUser(withEmail: email)
        return user != nil
    }
    
    func registerWebsiteCredentialForUser(email: String, websiteCredential: WebsiteCredential) {
        
        guard let user = getUser(withEmail: email) else{
            fatalError("user not found")
        }
        try! realm.write {
            user.websiteCredentials.append(websiteCredential)
        }
        
    }
    
    func createWebsiteCredential(email: String, url: String) {
        let websiteCredential = WebsiteCredential()
        websiteCredential.email = email
        websiteCredential.url = url
        
        try! realm.write {
            realm.add(websiteCredential)
        }
    }
    
    func createUser(email: String, token: String) {
        let user = Person()
        user.email = email
        
        try! realm.write {
            realm.add(user)
        }
    }
    
    func deleteFromDatabase(_ object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func deleteAllDatabase() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func addWebCredentialsForCurrentUserForTesting() {
        
        let results = realm.objects(WebsiteCredential.self)
        try! realm.write {
            realm.delete(results)
        }
        let google = WebsiteCredential()
        google.email = "danilo@gmail.com"
        google.name = "Gmail"
        google.url = "google.com"
        
        let facebook = WebsiteCredential()
        facebook.email = "sim_danilo@hotmail.com"
        facebook.name = "Facebook Ppincipal"
        facebook.url = "facebook.com"
        
        let facebookFake = WebsiteCredential()
        facebookFake.email = "danilo@outlook.com"
        facebookFake.name = "Reddit"
        facebookFake.url = "reddit.com"
        
        let last = WebsiteCredential()
        last.email = "danilo@outlook.com"
        last.name = "LastFM"
        last.url = "last.fm"
        
        
        registerWebsiteCredentialForUser(email: SharedPreference.shared.getStoredEmail()!, websiteCredential: google)
        registerWebsiteCredentialForUser(email: SharedPreference.shared.getStoredEmail()!, websiteCredential: facebook)
        registerWebsiteCredentialForUser(email: SharedPreference.shared.getStoredEmail()!, websiteCredential: facebookFake)
        registerWebsiteCredentialForUser(email: SharedPreference.shared.getStoredEmail()!, websiteCredential: last)
        
    }
    
    
    private func getUser(withEmail email: String ) -> Person? {
        return realm.objects(Person.self).filter("email == %@", email).first
    }
    

}

















