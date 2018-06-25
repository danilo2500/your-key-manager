//
//  WebsiteCredential.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 24/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import RealmSwift

class WebsiteCredential: Object {
    @objc dynamic var id = 0
    @objc dynamic var url = ""
    @objc dynamic var email = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
