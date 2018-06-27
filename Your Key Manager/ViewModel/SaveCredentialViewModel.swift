//
//  saveCredentialViewModel.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 26/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import Foundation
import RxSwift

class SaveCredentialViewModel {
    
    let URL = Variable<String>("")
    let name = Variable<String>("")
    let email = Variable<String>("")
    let password = Variable<String>("")
    
    var canSaveCredential: Observable<Bool> {
        return Observable.combineLatest(email.asObservable(), password.asObservable(), name.asObservable(), URL.asObservable()){
            email, password, name, URL in
            return not(email.isEmpty) && not(password.isEmpty) && not(name.isEmpty) && not(URL.isEmpty)
        }
    }
    
    func saveOrUpdateWebCredentialOnDatabase(email: String, url: String, name: String, password: String) {
        saveWebCredentialOnDatabase(email: email, url: url, name: name, password: password)
    }
    
    func saveWebCredentialOnDatabase(email: String, url: String, name: String, password: String) {
        let websiteCredentia = WebsiteCredential()
        websiteCredentia.email = email
        websiteCredentia.url = url
        websiteCredentia.name = name
        let currentUserEmail = SharedPreference.shared.getStoredEmail()!
        RealmManager.shared.registerWebsiteCredentialForUser(email: currentUserEmail, websiteCredential: websiteCredentia)
        KeychainManager.shared.storeWebsitePassword(websiteURL: email, password: password)
    }
    
    private func updateWebCredentialOnDatabase() {
        
    }
}
