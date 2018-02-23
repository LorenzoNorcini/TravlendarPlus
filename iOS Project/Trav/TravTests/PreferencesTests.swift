//
//  PreferencesTests.swift
//  TravTests
//
//  Created by Tommaso Scarlatti on 30/12/2017.
//  Copyright © 2017 Tommaso Scarlatti. All rights reserved.
//

import XCTest

@testable import Trav


class PreferencesTests: XCTestCase {
    
    //Insert token here
    let token = ""
    
    var pvc: PreferencesViewController?
    
    override func setUp() {
        super.setUp()
        
        pvc = PreferencesViewController()
        
        Preferences.busOn = true
        Preferences.bikeOn = true
        Preferences.carOn = true
        Preferences.uberOn = true
        Preferences.walkingOn = true
        
        Preferences.busMaxDistance = 10000
        Preferences.bikeMaxDistance = 10000
        Preferences.carMaxDistance = 10000
        Preferences.uberMaxDistance = 10000
        Preferences.walkingMaxDistance = 10000
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetPreferences() {
        let ex = expectation(description: "Expecting a value of statusCode == 200")
        
        pvc!.savePreferences(authenticateWith: token) { (statusCode) in
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
