//
//  SettingsTest.swift
//  TravTests
//
//  Created by Tommaso Scarlatti on 30/12/2017.
//  Copyright © 2017 Tommaso Scarlatti. All rights reserved.
//

import XCTest

@testable import Trav

class SettingsTest: XCTestCase {
    
    //Insert token here
    let token = ""
    
    var svc: SettingsViewController?
    
    override func setUp() {
        super.setUp()
        svc = SettingsViewController()
        
        getUserId()
    }
    
    func getUserId() {
        let ex = expectation(description: "Expecting to retrieve the user id")
        getUserCredentials(authenticateWith: token) { (statusCode, data) in
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    // Test if the settings set are correctly received from the server
    func testSettingsSaved() {
        let ex = expectation(description: "Expecting a value of statusCode == 200")
        
        svc?.newName = "New Name"
        
        svc!.saveSettings(authenticateWith: token) { (statusCode) in
            XCTAssertEqual(statusCode, 200)
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
}
