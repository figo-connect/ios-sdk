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
    
    func testThatRetrieveAccountsYieldsObjects() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.retrieveAccounts() { result in
            switch result {
            case .Success(let accounts):
                XCTAssertGreaterThan(accounts.count, 0)
                break
            case .Failure(let error):
                XCTFail(error.localizedFailureReason ?? "no failure reason was provided")
                break
            }
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatRetrieveAccountYieldsObject() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.retrieveAccount("A1079434.5") { result in
            switch result {
            case .Success(let account):
                XCTAssertEqual(account.account_number!, "1146174")
                break
            case .Failure(let error):
                XCTFail(error.localizedFailureReason ?? "no failure reason was provided")
                break
            }
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
}
