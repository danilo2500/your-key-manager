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
    
    func getAllWebCredentialsForDebug() -> [WebsiteCredential]{
        let results = realm.objects(WebsiteCredential.self)
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
    
    func createWebsiteCredential(email: String, url: String, name: String) {
        let websiteCredential = WebsiteCredential()
        websiteCredential.email = email
        websiteCredential.name = name
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
    
    func update(webCredential: WebsiteCredential ,withEmail email: String, name: String, url: String) {

        try! realm.write {
            webCredential.email = email
            webCredential.name = name
            webCredential.url = url
        }
    }
    
    private func getUser(withEmail email: String ) -> Person? {
        return realm.objects(Person.self).filter("email == %@", email).first
    }
    

}

















