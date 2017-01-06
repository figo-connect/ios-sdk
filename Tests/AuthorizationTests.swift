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
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            self.logout() {
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testThatLoginWithWrongPasswordYieldsCorrectError() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        figo.loginWithUsername(username, password: "foo", clientID: clientID, clientSecret: clientSecret) { result in
            XCTAssertNotNil(result.error)
            if case .failure(let error) = result {
                XCTAssert(error.description.contains("Invalid credentials"))
            }
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testThatRetrieveWithoutLoginYieldsCorrectError() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        logout() {
            figo.retrieveAccounts() { result in
                XCTAssertNotNil(result.error)
                if case .failure(let error) = result {
                    XCTAssert(error.description.hasPrefix("No Figo session active"))
                }
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testThatRevokeRefreshTokenRevokesAuthorization()
    {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login {
            figo.revokeRefreshToken(self.refreshToken!) { result in
                XCTAssertNil(result.error)
                figo.retrieveAccounts() { result in
                    XCTAssertNotNil(result.error)
                    self.logout() {
                        expectation.fulfill()
                    }
                }
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testThatLoginWithRefreshTokenYieldsAccessToken() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            figo.revokeAccessToken { result in
                XCTAssertNil(result.error)
                figo.loginWithRefreshToken(figo.refreshToken!, clientID: self.clientID, clientSecret: self.clientSecret) { result in
                    XCTAssertNil(result.error)
                    self.logout() {
                        expectation.fulfill()
                    }
                }
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
}
