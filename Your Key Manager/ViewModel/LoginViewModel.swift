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
    
    var apiManager: DevPeopleAPIManager!
    
    init(apiManager: DevPeopleAPIManager) {
        self.apiManager = apiManager
    }
    
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
            
            if let user = user {
                KeychainManager.shared.storeUserPassword(email: email, password: password)
                SharedPreference.shared.saveTagIndicatingLoginIsStored()
                SharedPreference.shared.store(email: email)
                SharedPreference.shared.store(token: user.token)
            }
            
            completion(user,errorDescription)
        }
        
    }
    
    func getEmailUsedOnLastLogin() -> String? {
        return SharedPreference.shared.getStoredEmail()
    }
    
    func shouldHideBiometryOptions() -> Bool {
        let hasLoginKeyStored = SharedPreference.shared.hasLoginKeyStored()
        let isBiometricIDSupported = BiometricIDAuth().isBiometricIDSupported()
        let userAlreadyAuthenticatedOnTouchID = SharedPreference.shared.userAlreadyAuthenticatedOnTouchID()
        let canSupportBiometry = hasLoginKeyStored && isBiometricIDSupported && userAlreadyAuthenticatedOnTouchID
        return not(canSupportBiometry)
    }
    
}


































