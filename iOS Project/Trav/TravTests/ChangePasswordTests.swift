//
//  ChangePasswordTests.swift
//  TravTests
//
//  Created by Tommaso Scarlatti on 05/01/2018.
//  Copyright © 2018 Tommaso Scarlatti. All rights reserved.
//

import XCTest

@testable import Trav

class ChangePasswordTests: XCTestCase {
    
    let oldPsw = "travlendar"
    let newPsw = "travlendar"
    
    //Insert token here
    let token = ""
    
    var changePswVC: ChangePasswordViewController?
    
    override func setUp() {
        super.setUp()
        
        changePswVC = ChangePasswordViewController()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSetNewPassword() {
        let ex = expectation(description: "Expecting status code == 200")
        
        changePswVC?.changePasswordAndSendToServer(authenticateWith: token, userId: 924, oldPsw: oldPsw, newPsw: newPsw) { (statusCode, data) in
            XCTAssertEqual(statusCode, 200)
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }

}
