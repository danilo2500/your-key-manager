//
//  RegisterViewModel.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 23/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class RegisterViewModel {
    
    let apiManager = DevPeopleAPIManager()
    
    var email = Variable<String>("")
    var password = Variable<String>("")
    var name = Variable<String>("")
    
    var isCreatingUser = Variable<Bool>(false)
    
    var canCreateUser: Observable<Bool> {
        return Observable.combineLatest(email.asObservable(), password.asObservable(), name.asObservable(), isCreatingUser.asObservable()){
            [unowned self] email, password, name, isCreatingUser in
            return Util.isValid(email: email) && Util.isValid(password: password) && self.nameIsntEmpty(name) && not(isCreatingUser)
        }
    }
    
    func nameIsntEmpty(_ name: String) -> Bool {
        return not(name.isEmpty)
    }
    
    func createUser(email: String, password: String, name: String,  completion: @escaping (User?, Error?) -> Void) {
        
        isCreatingUser.value = true
        
        apiManager.createUser(email: email, password: password, name: name) { [unowned self] (user, error) in
            
            self.isCreatingUser.value = false
            
            if user != nil {
                KeychainManager.shared.saveLoginCredentials(email: email, password: password)
            }
            completion(user, error)
        }
    }
    
    func getErrorDescription(_ error: Error) -> String {
        let moyaError = error as? MoyaError
        let response = moyaError?.response
        let statusCode = response?.statusCode ?? 0
        switch statusCode {
        case 401:
            return "Usuário não autorizado"
        case 403:
            return "Usuário ou senha incorreta"
        case 408:
            return "Tempo de solicitação esgotado"
        case 409:
            return "Este e-mail já possui um cadastro"
        default:
            return "Um erro inesperado aconteceu ao tentar se conectar com os servidores"
        }
    }
}



































