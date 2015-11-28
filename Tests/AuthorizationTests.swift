//
//  AuthorizationTests.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
@testable import Figo


class AuthorizationTests: BaseTestCaseWithLogin {
    
    func testThatLoginAndLogoutBaseTestCasesRunWithoutErrors() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        login() {
            self.logout() {
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatLoginWithWrongPasswordYieldsCorrectError() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        figo.loginWithUsername(username, password: "foo") { authorization, error in
            XCTAssertNotNil(error)
            XCTAssert(error!.failureReason.containsString("Invalid credentials"))
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatRetrieveWithoutLoginYieldsCorrectError() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        figo.retrieveAccounts() { _, error in
            XCTAssertNotNil(error)
            switch error! {
            case .NoActiveSession:
                break
            default:
                XCTFail()
            }
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatRevokeRefreshTokenRevokesAuthorization()
    {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        login {
            self.figo.revokeRefreshToken(self.refreshToken!) { error in
                XCTAssertNil(error)
                self.figo.retrieveAccounts() { _, error in
                    XCTAssertNotNil(error)
                    self.logout() {
                        expectation.fulfill()
                    }
                }
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatLoginWithRefreshTokenYieldsAccessToken() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        login() {
            self.figo.revokeAccessToken { (error) -> Void in
                XCTAssertNil(error)
                self.figo.loginWithRefreshToken(self.figo.refreshToken!, clientID: "", clientSecret: "") { error in
                    XCTAssertNil(error)
                    self.logout() {
                        expectation.fulfill()
                    }
                }
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
}
