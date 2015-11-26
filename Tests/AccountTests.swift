//
//  Figo_iOS_Tests.swift
//  Figo iOS Tests
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
@testable import Figo


class RetrievalTests: BaseTestCaseWithLogin {
    
    func testShowsSimplestRetrieveAccountsCallWithoutErrorHandling() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.retrieveAccounts() { accounts, _ in
            if let accounts = accounts {
                XCTAssertGreaterThan(accounts.count, 0)
            }
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatRetrieveAccountsYieldsObjects() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.retrieveAccounts() { accounts, error in
            if let accounts = accounts {
                XCTAssertGreaterThan(accounts.count, 0)
            }
            XCTAssertNil(error)
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatRetrieveAccountYieldsObject() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.retrieveAccount("A1079434.5") { account, error in
            if let account = account {
                XCTAssertEqual(account.account_number, "1146174")
            }
            XCTAssertNil(error)
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
}
