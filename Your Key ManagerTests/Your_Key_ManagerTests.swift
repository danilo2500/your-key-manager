//
//  Your_Key_ManagerTests.swift
//  Your Key ManagerTests
//
//  Created by Danilo Henrique on 22/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import XCTest
@testable import Your_Key_Manager

class Your_Key_ManagerTests: XCTestCase {
    
    override func setUp() {
        
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmailValidation() {
        let email = "wrongformat@mail"
        let isValidEmail = Util.isValid(email: email)
        XCTAssertFalse(isValidEmail)
    }
    
    func testCorrectEmailValidation() {
        let email = "name@mail.com"
        let isValidEmail = Util.isValid(email: email)
        XCTAssertTrue(isValidEmail)
    }
    
    func testWrongPassword() {
        let password = "wrong password"
        let isValidPassword = Util.isValid(password: password)
        XCTAssertFalse(isValidPassword)
    }
    
    func testCorrectPassword() {
        let password = "12345@Aa"
        let isValidPassword = Util.isValid(password: password)
        XCTAssertTrue(isValidPassword)
    }
    
    func testPasswordSaving() {
        let password = "12345@Aa"
        KeychainManager.shared.storeUserPassword(email: "test@mail.com", password: "12345@Aa")
        let requestedPassword = KeychainManager.shared.getUserPassword(email: "test@mail.com")
        
        XCTAssertEqual(password, requestedPassword)
    }
}
