//
//  Figo_iOS_Tests.swift
//  Figo iOS Tests
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Alamofire
@testable import Figo


class DemoTestCases: XCTestCase {
    
    let demoAccessToken = "ASHWLIkouP2O6_bgA2wWReRhletgWKHYjLqDaqb0LFfamim9RjexTo22ujRIP_cjLiRiSyQXyt2kM1eXU2XLFZQ0Hro15HikJQT_eNeT_9XQ"
    
    override func setUp() {
        super.setUp()
        Figo.login(accessToken: demoAccessToken)
    }

    func testRetrieveAccounts() {
        let resultArrived = self.expectationWithDescription("result arrived")
        Figo.retrieveAccounts() { result in
            if let accounts = result.value {
                XCTAssertGreaterThan(accounts.count, 0)
            }
            else {
                XCTFail()
            }
            resultArrived.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testRetrieveAccountsWithResultChecking() {
        let resultArrived = self.expectationWithDescription("result arrived")
        Figo.retrieveAccounts() { result in
            switch result {
                case .Success(let accounts):
                    XCTAssertGreaterThan(accounts.count, 0)
                    break
                case .Failure(let error):
                    XCTFail(error.localizedFailureReason ?? "no failure reason was provided")
                    break
            }
            resultArrived.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testRetrieveAccount() {
        let resultArrived = self.expectationWithDescription("result arrived")
        Figo.retrieveAccount("A1.1") { result in
            switch result {
            case .Success(let account):
                XCTAssertEqual(account.account_number!, "4711951500")
                break
            case .Failure(let error):
                XCTFail(error.localizedFailureReason ?? "no failure reason was provided")
                break
            }
            resultArrived.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
}
