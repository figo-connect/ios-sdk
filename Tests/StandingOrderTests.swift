//
//  StandingOrderTests.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


import XCTest
import Figo


class StandingOrderTests: BaseTestCaseWithLogin {
    
    func testThatRetrieveStandingOrdersForAccountYieldsNoErrors() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        login() {
            figo.retrieveStandingOrdersForAccount("A1182805.4") { result in
                if case .success(let orders) = result {
                    print("Retrieved \(orders.count) standing orders")
                }
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testThatRetrieveStandingOrdersYieldsNoErrors() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        login() {
            figo.retrieveStandingOrders() { result in
                if case .success(let orders) = result {
                    print("Retrieved \(orders.count) standing orders")
                }
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
}
