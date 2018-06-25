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
    
    private let devPeopleProvider = MoyaProvider<DevPeopleAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private let disposeBag = DisposeBag()
    
    func signIn(email: String, password: String, completion: @escaping (User?, Error?) -> Void) {
        devPeopleProvider.rx.request(.signIn(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(User.self)
            .subscribe({ (event) in
                switch event {
                case let .success(user):
                    completion(user, nil)
                case let .error(error):
                    completion(nil, error)
                }
            }).disposed(by: disposeBag)
    }
    
    func createUser(email: String, password: String, name: String, completion: @escaping (User?, Error?) -> Void) {
        devPeopleProvider.rx.request(.createUser(email: email, password: password, name: name))
            .filterSuccessfulStatusCodes()
            .map(User.self)
            .subscribe({ (event) in
                switch event {
                case let .success(user):
                    completion(user, nil)
                case let .error(error):
                    completion(nil, error)
                }
            }).disposed(by: disposeBag)
    }
    
    func requestLogo(websiteURL: String, token: String, completion: @escaping (UIImage?, Error?) -> Void) {
        devPeopleProvider.rx.request(.logo(websiteURL: websiteURL, token: token))
            .filterSuccessfulStatusCodes()
            .mapImage()
            .subscribe({ (event) in
                switch event{
                case let .success(logoImage):
                    completion(logoImage, nil)
                case let .error(error):
                    completion(nil, error)
                }
            }).disposed(by: disposeBag)
    }
    
}
