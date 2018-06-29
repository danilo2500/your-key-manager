//
//  Person.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 24/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import RealmSwift

class Person: Object {
    
    @objc dynamic var email = ""
    let websiteCredentials = List<WebsiteCredential>()
    
    @objc dynamic var id = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
}
