//
//  AuthorizationTests.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class AuthorizationTests: BaseTestCaseWithLogin {
    
    
    
    func testThatLoginWithWrongPasswordYieldsCorrectError() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        figo.loginWithUsername(username, password: "foo") { authorization, error in
            XCTAssertNotNil(error)
            XCTAssert(error!.failureReason.containsString("Invalid credentials"))
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatRetrieveWithoutLoginYieldsCorrectError() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        figo.retrieveAccounts() { _, error in
            XCTAssertNotNil(error)
            switch error! {
            case .NoActiveSession:
                break
            default:
                XCTFail()
            }
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatRevokeRefreshTokenRevokesAuthorization()
    {
        login()
        logout()
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        figo.retrieveAccounts() { _, error in
            XCTAssertNotNil(error)
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
}
