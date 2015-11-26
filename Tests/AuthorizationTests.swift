//
//  AuthorizationTests.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class AuthorizationTests: XCTestCase {
    
    let username = "christian@koenig.systems"
    let password = "eVPVdiL7a8EUAP"
    let clientID = "C3XGp3LGISZFwJSsDfxwhHvXT1MjCoF92lOJ3VZrKeBI"
    let clientSecret = "SJtBMNCn6KrIkjQSCkV-xU3_ob0sUTHAFLy-K1V86SpY"
    
    func testThatLoginYieldsRefreshToken() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.loginWithUsername(username, password: password, clientID: clientID, clientSecret: clientSecret) { refreshToken, error in
            XCTAssertNotNil(refreshToken)
            XCTAssertNil(error)
            Figo.revokeRefreshToken(refreshToken) { error in
                XCTAssertNil(error)
                callbackExpectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatLoginWithWrongPasswordYieldsCorrectError() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.loginWithUsername(username, password: "foo", clientID: clientID, clientSecret: clientSecret) { authorization, error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.failureReason, "Invalid credentials")
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
        
        // After a failed login we need to login with correct credentials to avoid locking the account
        testThatLoginYieldsRefreshToken()
    }
    
    func testThatRetrieveWithoutLoginYieldsCorrectError() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.retrieveAccounts() { _, error in
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
    
    // After revoking the access token, a new one is fetched automatically if the refresh token is still valid
    func testThatExpiredAccessTokenTriggersRefreshAndYieldsNewToken() {
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
    
    func testThatRevokeRefreshTokenRevokesAuthorization()
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
