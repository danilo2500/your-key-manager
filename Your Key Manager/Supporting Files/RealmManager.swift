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
        guard let user = realm.object(ofType: Person.self, forPrimaryKey: "email == \(email)") else{
            return nil
        }
        
        return Array(user.websiteCredentials)
    }

    func getAllUsersForDebug() -> [Person] {
        let results = realm.objects(Person.self)
        return Array(results)
    }
    
    func registerWebsiteCredentialForUser(email: String, websiteCredential: WebsiteCredential) {
        
        guard let user = realm.objects(Person.self).filter("email == %@", email).first else{
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
    
    func createUser(email: String) {
        let user = Person()
        user.email = email
        
        try! realm.write {
            realm.add(user)
        }
    }
}
