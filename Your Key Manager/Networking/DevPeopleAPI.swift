//
//  DevPeopleAPI.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 22/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import Moya

enum DevPeopleAPI {
    case createUser(email: String, password: String, name: String)
    case signIn(email: String, password: String)
    case requestLogo(websiteURL: String, websiteToken: String)
}

extension DevPeopleAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Constants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .createUser:
            return "/register"
        case .signIn:
            return "/login"
        case .requestLogo(let websiteURL, _):
            return "/logo/\(websiteURL)"
        }
    }
    
    var method: Method {
        switch self {
        case .createUser, .signIn:
            return .post
        case .requestLogo:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .createUser(let email, let password, let name):
            var parameters: [String: Any] = [:]
            parameters["email"] = email
            parameters["name"] = name
            parameters["password"] = password
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .signIn(let email, let password):
            var parameters: [String: Any] = [:]
            parameters["login"] = email
            parameters["password"] = password
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .requestLogo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createUser, .signIn:
            return ["Content-type": "application/json"]
        case .requestLogo(_, let websiteToken):
            return ["authorization": websiteToken]
        }
    }
    
}




























