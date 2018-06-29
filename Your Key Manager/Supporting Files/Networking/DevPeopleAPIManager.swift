//
//  devPeopleAPIManager.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 23/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import Moya
import RxSwift

class DevPeopleAPIManager {
    static let shared = DevPeopleAPIManager()
    
    private init() {}
    
    private let devPeopleProvider = MoyaProvider<DevPeopleAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private let disposeBag = DisposeBag()

    func signIn(email: String, password: String, completion: @escaping (User?, String?) -> Void) {
        
        devPeopleProvider.rx.request(.signIn(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(User.self)
            .subscribe({ [unowned self] (event) in
                switch event {
                case let .success(user):
                    completion(user, nil)
                case let .error(error):
                    let errorDescription = self.getErrorDescription(error)
                    completion(nil, errorDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func createUser(email: String, password: String, name: String, completion: @escaping (User?, String?) -> Void) {
        devPeopleProvider.rx.request(.createUser(email: email, password: password, name: name))
            .filterSuccessfulStatusCodes()
            .map(User.self)
            .subscribe({ (event) in
                switch event {
                case let .success(user):
                    completion(user, nil)
                case let .error(error):
                    let errorDescription = self.getErrorDescription(error)
                    completion(nil, errorDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    func requestLogo(websiteUrl: String, token: String, completion: @escaping (UIImage?, String?) -> Void) {
        devPeopleProvider.rx.request(.logo(websiteURL: websiteUrl, token: token))
            .filterSuccessfulStatusCodes()
            .mapImage()
            .subscribe({ [unowned self] (event) in
                switch event{
                case let .success(logoImage):
                    completion(logoImage, nil)
                case let .error(error):
                    let errorDescription = self.getErrorDescription(error)
                    completion(nil, errorDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    private func getErrorDescription(_ error: Error ) -> String{
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



























