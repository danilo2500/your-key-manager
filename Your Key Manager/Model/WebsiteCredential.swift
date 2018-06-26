//
//  WebsiteCredential.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 24/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import RealmSwift
import RxSwift

class WebsiteCredential: Object {
    
    @objc dynamic var url = ""
    @objc dynamic var email = ""
    
    @objc dynamic var id = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
