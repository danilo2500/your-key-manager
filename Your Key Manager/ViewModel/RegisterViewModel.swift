//
//  RegisterViewModel.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 23/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

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

class RegisterViewModel {
    
    let apiManager = DevPeopleAPIManager()
    
    var email = Variable<String>("")
    var password = Variable<String>("")
    var name = Variable<String>("")
    
    var AllCredentialsAreValid: Observable<Bool> {
        return Observable.combineLatest(email.asObservable(), password.asObservable(), name.asObservable()){
            [unowned self] email, password, name in
            return self.isValidEmail(email: email) && self.isValidPassword(password: password) && self.nameIsntEmpty(name: name)
        }
    }
    
    func isValidPassword(password:String) -> Bool {
        let PasswordPredicate = NSPredicate(format:"SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$")
        return PasswordPredicate.evaluate(with: password)
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailPredicate.evaluate(with: email)
    }
    
    func nameIsntEmpty(name: String) -> Bool{
        return not(name.isEmpty)
    }
    
    func createUser(completion: @escaping (User?, Error?) -> Void){
        apiManager.createUser(email: email.value, password: password.value, name: name.value) { (user, error) in
            completion(user, error)
        }
    }
    
    func getErrorDescription(_ error: Error) -> String{
        let moyaError = error as? MoyaError
        let response = moyaError?.response
        let statusCode = response?.statusCode ?? 0
        return getStatusCodeErrorMessage(statusCode)
    }
    
    private func getStatusCodeErrorMessage(_ statusCode: Int) -> String{
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



































