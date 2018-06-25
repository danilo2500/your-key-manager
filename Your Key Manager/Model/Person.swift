//
//  Person.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 24/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import RealmSwift

class Person: Object {
    @objc dynamic var id = 0
    @objc dynamic var email = ""
    let websiteCredentials = List<WebsiteCredential>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
