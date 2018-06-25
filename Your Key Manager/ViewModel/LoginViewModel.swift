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
            email, password, isLoginIn  in
            return Util.isValid(email: email) && Util.isValid(password: password) && not(isLoginIn)
        }
        
    }

    func signIn(email: String, password: String, completion: @escaping (User?, String?) -> Void) {
        
        isLoginIn.value = true
        
        apiManager.signIn(email: email, password: password) { [unowned self] (user, errorDescription) in
            
            self.isLoginIn.value = false
            
            if user != nil {
                KeychainManager.shared.saveLoginCredentials(email: email, password: password)
            }
            
            completion(user,errorDescription)
        }
    }
    
    func getEmailUsedOnLastLogin() -> String? {
        return KeychainManager.shared.getStoredEmail()
    }
    
}


































