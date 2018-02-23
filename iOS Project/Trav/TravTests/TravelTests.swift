//
//  TravelTests.swift
//  TravTests
//
//  Created by Tommaso Scarlatti on 02/01/2018.
//  Copyright © 2018 Tommaso Scarlatti. All rights reserved.
//

import XCTest

@testable import Trav

class TravelTests: XCTestCase {
    
    //Insert token here
    let token = ""
    
    
    var travelVC: TravelViewController?
    
    override func setUp() {
        super.setUp()
    
        travelVC = TravelViewController()
        travelVC?.eventToGetTravelOptions = EventToGetTravelOptions(title: "Test Event",
                                                                    description: "Test Description",
                                                                    start: 1000,
                                                                    end: 5000,
                                                                    longitude: 9.204283,
                                                                    latitude: 45.485888,
                                                                    category: "green",
                                                                    travel: true,
                                                                    flexible: false,
                                                                    repetitive: false,
                                                                    startLongitude: 9.216384,
                                                                    startLatitude: 45.486163,
                                                                    duration: 500)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetTravels() {
        
        let ex = expectation(description: "Expecting a value of statusCode == 200")
        
        travelVC?.getTravelOptions(authenticateWith: token) { (statusCode, data) in
            XCTAssertEqual(statusCode, 200)
            XCTAssertNotNil(travelsOfSelectedEvent)
            XCTAssertGreaterThan(travelsOfSelectedEvent!.count, 0)
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
}
