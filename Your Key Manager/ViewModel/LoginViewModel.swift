//
//  LoginViewModel.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 23/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

class LoginViewModel {
    
    let apiManager = DevPeopleAPIManager()
    
    var email = Variable<String>("")
    var password = Variable<String>("")
    
    var isLoginIn = Variable<Bool>(false)
    
    var canLoginIn: Observable<Bool> {
        return Observable.combineLatest(email.asObservable(), password.asObservable(), isLoginIn.asObservable()){
            [unowned self] email, password, isLoginIn  in
            return self.isValidEmail(email: email) && self.isValidPassword(password: password) && not(isLoginIn)
        }
        
    }
    
    func isValidPassword(password:String) -> Bool {
        let PasswordPredicate = NSPredicate(format:"SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~])[A-Za-z\\dd!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]{8,}")
        return PasswordPredicate.evaluate(with: password)
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailPredicate.evaluate(with: email)
    }
    
    func signIn(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        
        isLoginIn.value = true
        
        apiManager.signIn(email: email, password: password) { [unowned self] (user, error) in
            
            self.isLoginIn.value = false
            
            if user != nil {
                KeychainManager.shared.saveLoginCredentials(email: email, password: password)
            }
            
            completion(user,error)
        }
    }
    
    func getEmailUsedOnLastLogin() -> String? {
        return KeychainManager.shared.getStoredEmail()
    }
    
    func getErrorDescription(_ error: Error) -> String{
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
        default:
            return "Um erro inesperado aconteceu ao tentar se conectar com os servidores"
        }
    }
    
}


































