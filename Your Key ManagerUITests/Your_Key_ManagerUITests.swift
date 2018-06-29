//
//  Your_Key_ManagerUITests.swift
//  Your Key ManagerUITests
//
//  Created by Danilo Henrique on 22/06/18.
//  Copyright © 2018 Danilo Henrique. All rights reserved.
//

import XCTest

class Your_Key_ManagerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        
        let app = XCUIApplication()
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["Clear text"]/*[[".textFields[\"E-mail\"].buttons[\"Clear text\"]",".buttons[\"Clear text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"retorno\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        

        let eMailTextField = app.textFields["E-mail"]
        eMailTextField.tap()
        eMailTextField.typeText("test@hotmail.com")
        returnButton.tap()
        
        let senhaSecureTextField = app.secureTextFields["Senha"]
        senhaSecureTextField.tap()
        senhaSecureTextField.typeText("12345678910aA@")
        returnButton.tap()
        app.buttons["Entrar"].tap()
        
    }
    
    func testCreateAccount() {
        
        let app = XCUIApplication()
        app.buttons["Criar uma conta"].tap()
        
        let eMailTextField = app.textFields["E-mail"]
        eMailTextField.tap()
        let randomString = NSUUID().uuidString
        eMailTextField.typeText("\(randomString)@mail.com")
        
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"retorno\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        returnButton.tap()
        
        let senhaSecureTextField = app.secureTextFields["Senha"]
        senhaSecureTextField.tap()
        senhaSecureTextField.typeText("12345678910aA@")

        returnButton.tap()
        
        let nomeTextField = app.textFields["Nome"]
        nomeTextField.tap()
        nomeTextField.typeText("nane")
        
        returnButton.tap()
        app.buttons["Criar nova conta"].tap()
    }
    
    
    
    func testWrongPasswordValidation() {
        
        let app = XCUIApplication()
        app.buttons["Criar uma conta"].tap()
        
        let eMailTextField = app.textFields["E-mail"]
        eMailTextField.tap()
        eMailTextField.typeText("test@mail.com")
        
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"retorno\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        returnButton.tap()
        
        let senhaSecureTextField = app.secureTextFields["Senha"]
        senhaSecureTextField.tap()
        senhaSecureTextField.typeText("wrong password")
        
        returnButton.tap()
        
        let nomeTextField = app.textFields["Nome"]
        nomeTextField.tap()
        nomeTextField.typeText("nane")
        
        returnButton.tap()
        
        let createAccountButton = app.buttons["Criar nova conta"]
        
        XCTAssertFalse(createAccountButton.isEnabled)
    }
    
    func testLoginCredentialsValidation() {
        let app = XCUIApplication()
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["Clear text"]/*[[".textFields[\"E-mail\"].buttons[\"Clear text\"]",".buttons[\"Clear text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let eMailTextField = app.textFields["E-mail"]
        eMailTextField.tap()
        eMailTextField.typeText("test@hotmail.com")
        
        let signInButton = app.buttons["Entrar"]
        
        XCTAssertFalse(signInButton.isEnabled)
    }
    
}
