//
//  LoginTestCases.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
@testable import Figo


class LoginTests: XCTestCase {
    
    let username = "christian@koenig.systems"
    let password = "eVPVdiL7a8EUAP"
    let clientID = "C3XGp3LGISZFwJSsDfxwhHvXT1MjCoF92lOJ3VZrKeBI"
    let clientSecret = "SJtBMNCn6KrIkjQSCkV-xU3_ob0sUTHAFLy-K1V86SpY"
    
    
    override func tearDown() {
        Figo.discardSession()
        super.tearDown()
    }
    
    func testThatLoginYieldsAccessToken() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.loginWithUsername(username, password: password, clientID: clientID, clientSecret: clientSecret) { authorization, error in
            guard let authorization = authorization else {
                XCTFail(error?.failureReason ?? "no failure reason was provided")
                return
            }
            XCTAssertNotNil(authorization.access_token)
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatLoginWithWrongPasswordYieldsCorrectError() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.loginWithUsername(username, password: "foo", clientID: clientID, clientSecret: clientSecret) { authorization, error in
            guard let error = error else {
                XCTFail("Login should have failed")
                return
            }
            XCTAssertEqual(error.failureReason, "Invalid credentials")
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
        
        // After a failed login we need to login with correct credentials to avoid locking the account
        testThatLoginYieldsAccessToken()
    }
    
    func testThatRetrieveWithoutLoginYieldsCorrectError() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.retrieveAccounts() { _, error in
            guard let error = error else {
                XCTFail("Login should have failed")
                return
            }
            XCTAssert(error.failureReason.containsString("401 Unauthorized"))
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testRevokesAccessToken() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.loginWithUsername(username, password: password, clientID: clientID, clientSecret: clientSecret) { _, error in
            XCTAssertNil(error)
            Figo.revokeAccessToken() { error in
                XCTAssertNil(error)
                Figo.retrieveAccount("A1079434.5") { _, error in
                    XCTAssertNil(error)
                    callbackExpectation.fulfill()
                }
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testRevokeRefreshToken()
    {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.loginWithUsername(username, password: password, clientID: clientID, clientSecret: clientSecret) { _, error in
            XCTAssertNil(error)
            Figo.revokeRefreshToken(nil) { error in
                XCTAssertNil(error)
                Figo.retrieveAccount("A1079434.5") { _, error in
                    XCTAssertNotNil(error)
                    callbackExpectation.fulfill()
                }
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }

}