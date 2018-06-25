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
    private let realm = try! Realm()
    
    private init() {}
    
    func getWebsiteCredentials(forUser email: String) -> List<WebsiteCredential>? {
        let user = realm.object(ofType: Person.self, forPrimaryKey: "email == \(email)")
        
        return user?.websiteCredentials
    }
    
    func registerWebsiteCredentialForUser(email: String, websiteCredential: WebsiteCredential) {
        guard let user = realm.object(ofType: Person.self, forPrimaryKey: "email == \(email)") else {
            fatalError("User not found")
        }
        try! realm.write {
            user.websiteCredentials.append(websiteCredential)
        }
    }
    
    func registerUser(email: String) {
        let user = Person()
        user.email = email
        
        try! realm.write {
            realm.add(user)
        }
    }
}
