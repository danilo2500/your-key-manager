//
//  User.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 23/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import Foundation

struct User: Decodable {
    
    let type: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case token
    }
}
