//
//  DayTests.swift
//  TravTests
//
//  Created by Tommaso Scarlatti on 30/12/2017.
//  Copyright © 2017 Tommaso Scarlatti. All rights reserved.
//

import XCTest
import Nimble
import Quick

@testable import Trav

class DayTests: XCTestCase {
    
    struct EventToTest: Decodable {
        var events: [Event]
        var message: String
    }
    
    var dvc: DayViewController?
    var addvc: AddEventViewController?
    
    var dateFormatter: DateFormatter = DateFormatter()
    var date: Date?
    
    var addedEvents: [Event] = []
    var eventTimeBounds: [(Int, Int)]?
    
    //Insert token here
    let token = ""
    
    override func setUp() {
        super.setUp()
        dvc = DayViewController()
        addvc = AddEventViewController()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.date(from: "2018-12-01")
        print("DATA:", date!)
        
        // Events: 01-12-2018 13.00-12.30, 02-01-2018 15.00-15.30
        eventTimeBounds = [(1543662000, 1543663800), (1543672800, 1543674600)]
        
        let eventsGroup = DispatchGroup()
        
        let ex = expectation(description: "null")
        
        eventsGroup.enter()
        eventsGroup.enter()
        
        for etb in eventTimeBounds! {
            
            RawEventToBeAdded.title = "Test Title"
            RawEventToBeAdded.description = "Test Description"
            RawEventToBeAdded.start = etb.0
            RawEventToBeAdded.end = etb.1
            
            addvc!.addEventToServer(authenticateWith: token) { (statusCode, data) in
                if let json = data {
                    do {
                        let decodedEvent = try JSONDecoder().decode(EventToTest.self, from: json)
                        self.addedEvents.append(decodedEvent.events[0])
                    } catch {}
                }
                eventsGroup.leave()
            }
        }
        
        eventsGroup.notify(queue: .main, execute: {
            print("Finished all creation requests.")
            print(Date().timeIntervalSince1970)
            ex.fulfill()
        })
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
        
        
    }
    
    
    /// In order to make the tests nullable,
    override func tearDown() {
        let ex = expectation(description: "null")
        
        for index in 0 ..< addedEvents.count {
            print(addedEvents[index].id)
            dvc?.deleteEvent(authenticateWith: token, event: (addedEvents[index].id)!) { _ in
                ex.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
        
        super.tearDown()
    }
    
    
    /// Test that the number of events for the day: 01/12/2018 is 2
    func testEventsNumber() {

        let ex = expectation(description: "Expecting a number of events == 2 for the date: 01/12/2018")
        
        dvc?.getEvents(authenticateWith: token, of: date!) { (statusCode, data) in
            XCTAssertEqual(Day.eventsOfTheDay?.count, 2)
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

