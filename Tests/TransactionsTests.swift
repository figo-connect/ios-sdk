//
//  TransactionsTests.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class TransactionsTests: BaseTestCaseWithLogin {
    
    func testThatRetrieveTransactionForAccountYieldsNoErrors() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        
        login() {
            var parameters = RetrieveTransactionsParameters()
            parameters.since = "2015-11-30"

            self.figo.retrieveTransactionsForAccount("A1182805.4", parameters: parameters) { result in
                if case .Success(let envelope) = result {
                    print("Retrieved \(envelope.transactions.count) transactions")
                }
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatRetrieveTransactionsYieldsNoErrors() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        
        login() {
            var parameters = RetrieveTransactionsParameters()
            parameters.since = "2015-11-30"
            
            self.figo.retrieveTransactions(parameters) { result in
                if case .Success(let envelope) = result {
                    print("Retrieved \(envelope.transactions.count) transactions")
                }
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatRetrieveTransactionYieldsNoErrors() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        
        login() {

            self.figo.retrieveTransaction("T1182805.193") { result in
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
}