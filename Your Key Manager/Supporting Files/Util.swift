//
//  Util.swift
//  Your Key Manager
//
//  Created by Danilo Henrique on 23/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import Foundation

let not = (!)

class Util {
    static func isValid(password: String) -> Bool {
      
        let oneUperrcaseLetter = "(?=.*[a-z])"
        let oneLowercaseLetter = "(?=.*[A-Z])"
        let oneNumber = "(?=.*?[0-9])"
        //let oneSpecialCharacter = "(?i)^([[a-z][^a-z0-9\\s\\(\\)\\[\\]\\{\\}\\\\^\\$\\|\\?\\*\\+\\.\\<\\>\\-\\=\\!\\_]]*)"
        //let oneSpecialCharacter = "[.*[^A-Za-z0-9].*]"
        let oneSpecialCharacter = "(?=.*[!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\])"
        let EightCharacters = "{8,}"
    
        
        //let regex = "^" + oneLowercaseLetter + oneUperrcaseLetter + oneNumber + oneSpecialCharacter + EightCharacters
        //let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~])[A-Za-z\\dd!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]{8,}")
        
        return passwordPredicate.evaluate(with: password)
    }
    
    static func isValid(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return emailPredicate.evaluate(with: email)
    }
}
