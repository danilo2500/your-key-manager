//
//  saveCredentialViewModel.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 26/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import Foundation
import RxSwift

enum saveCredentialTask {
    case saving
    case updating
}

class SaveCredentialViewModel {
    
    var saveCredentialTask: saveCredentialTask! = nil
    
    lazy var userEmail = SharedPreference.shared.getStoredEmail()!
    
    var updatedWebCredential: WebsiteCredential!{
        didSet{
            email.value = updatedWebCredential.email
            name.value = updatedWebCredential.name
            URL.value = updatedWebCredential.url
            let storedPassword = KeychainManager.shared.getWebsitePassword(credentialID: updatedWebCredential.id)
            password.value = storedPassword
        }
    }
    
    let URL = Variable<String>("")
    let name = Variable<String>("")
    let email = Variable<String>("")
    let password = Variable<String>("")
    
    var canSaveCredential: Observable<Bool> {
        return Observable.combineLatest(email.asObservable(), password.asObservable(), name.asObservable(), URL.asObservable()){
            email, password, name, URL in
            print("email",email)
            print("URL",URL)
            print("password",password)
            print("name",name)
            print("------")
            return not(email.isEmpty) && not(password.isEmpty) && not(name.isEmpty) && not(URL.isEmpty)
        }
    }

    func saveOrUpdateWebCredentialOnDatabase(email: String, url: String, name: String, password: String) {
        if saveCredentialTask == .saving {
            saveWebCredentialOnDatabase(email: email, url: url, name: name, password: password)
        }
        if saveCredentialTask == .updating {
            updateWebCredentialOnDatabase(email: email, url: url, name: name, password: password)
        }
        
    }
    
    private func saveWebCredentialOnDatabase(email: String, url: String, name: String, password: String) {
        let websiteCredential = WebsiteCredential()
        websiteCredential.email = email
        websiteCredential.url = url
        websiteCredential.name = name
        let currentUserEmail = SharedPreference.shared.getStoredEmail()!
        RealmManager.shared.registerWebsiteCredentialForUser(email: currentUserEmail, websiteCredential: websiteCredential)
        KeychainManager.shared.storeWebsitePassword(credentialID: websiteCredential.id, password: password)
    }
    
    private func updateWebCredentialOnDatabase(email: String, url: String, name: String, password: String) {
        RealmManager.shared.update(webCredential: updatedWebCredential, withEmail: email, name: name, url: url )
        KeychainManager.shared.storeWebsitePassword(credentialID: updatedWebCredential.id, password: password)
    }
}
