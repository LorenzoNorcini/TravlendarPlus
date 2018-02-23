//
//  CalendarTests.swift
//  TravTests
//
//  Created by Tommaso Scarlatti on 03/01/2018.
//  Copyright © 2018 Tommaso Scarlatti. All rights reserved.
//

import XCTest

@testable import Trav

class CalendarTests: XCTestCase {
    
    var calendarVC: CalendarViewController?
    //Insert token here
    let token = ""
    
    override func setUp() {
        super.setUp()
        
        calendarVC = CalendarViewController()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetDaysWithEvents() {
        let ex = expectation(description: "Expecting a value of statusCode == 200")
        
        calendarVC!.getDaysWithEvent(authenticateWith: token) { (statusCode, data) in
            
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
