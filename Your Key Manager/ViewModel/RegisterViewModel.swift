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
    
    func createUser(email: String, password: String, name: String,  completion: @escaping (User?, String?) -> Void) {
        
        isCreatingUser.value = true
        
        apiManager.createUser(email: email, password: password, name: name) { [unowned self] (user, errorDescription) in
            
            self.isCreatingUser.value = false
            
            if let user = user {
                KeychainManager.shared.storeUserPassword(email: email, password: password)
                SharedPreference.shared.store(email: email)
                SharedPreference.shared.store(token: user.token)
                SharedPreference.shared.saveTagIndicatingLoginIsStored()
            }
            completion(user, errorDescription)
        }
    }
}



































