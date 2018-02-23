//
//  AddEventTests.swift
//  TravTests
//
//  Created by Tommaso Scarlatti on 30/12/2017.
//  Copyright © 2017 Tommaso Scarlatti. All rights reserved.
//

import XCTest

@testable import Trav

class AddEventTests: XCTestCase {
    
    struct EventToTest: Decodable {
        var events: [Event]
        var message: String
    }
    
    var addedEvent: Event?
    
    //Insert token here
    let token = ""
    
    var addEventVC: AddEventViewController?
    var dayVC: DayViewController?
    
    override func setUp() {
        super.setUp()
        addEventVC = AddEventViewController()
        dayVC = DayViewController()
    }
    
    // In order to make the effects of the test nullable, every added event is deleted
    override func tearDown() {
        let ex = expectation(description: "Expecting the deletion of the added event")
        
        dayVC?.deleteEvent(authenticateWith: token, event: (addedEvent?.id)!) { (statusCode) in
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
        
        super.tearDown()
    }
    
    func testAddEventWithNoTravel() {
        RawEventToBeAdded.title = "Test Title"
        RawEventToBeAdded.description = "Test Description"
        RawEventToBeAdded.start = 50000
        RawEventToBeAdded.end = 51000
        
        let ex = expectation(description: "Expecting a value of statusCode == 200")
        
        addEventVC!.addEventToServer(authenticateWith: token) { (statusCode, data) in
            XCTAssertEqual(statusCode, 200)
            
            if let json = data {
                do {
                    let decodedEvent = try JSONDecoder().decode(EventToTest.self, from: json)
                    self.addedEvent = decodedEvent.events[0]
                } catch {}
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    func testAddFlexibleEvent() {
        RawEventToBeAdded.title = "Test Flexible Event Title"
        RawEventToBeAdded.description = "Test Description"
        RawEventToBeAdded.start = 13000
        RawEventToBeAdded.end = 14000
        RawEventToBeAdded.isFlexible = true
        RawEventToBeAdded.duration = 500
        
        let ex = expectation(description: "Expecting a value of statusCode == 200")
        
        addEventVC!.addEventToServer(authenticateWith: token) { (statusCode, data) in
            XCTAssertEqual(statusCode, 200)
            
            if let json = data {
                do {
                    let decodedEvent = try JSONDecoder().decode(EventToTest.self, from: json)
                    self.addedEvent = decodedEvent.events[0]
                } catch {}
            }
            
            ex.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
   
}
