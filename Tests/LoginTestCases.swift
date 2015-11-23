//
//  LoginTestCases.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Alamofire
@testable import Figo


class LoginTestCases: XCTestCase {
    
    let username = "christian@koenig.systems"
    let password = "eVPVdiL7a8EUAP"
    let clientID = "C3XGp3LGISZFwJSsDfxwhHvXT1MjCoF92lOJ3VZrKeBI"
    let clientSecret = "SJtBMNCn6KrIkjQSCkV-xU3_ob0sUTHAFLy-K1V86SpY"
    
    func testThatLoginYieldsAccessToken() {
        let resultArrived = self.expectationWithDescription("result arrived")
        Figo.login(username: username, password: password, clientID: clientID, clientSecret: clientSecret) { result in
            switch result {
            case .Success(let authorization):
                XCTAssertNotNil(authorization.access_token)
                break
            case .Failure(let error):
                XCTFail(error.localizedFailureReason ?? "no failure reason was provided")
                break
            }
            resultArrived.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testThatLoginWithWrongPasswordYieldsCorrectError() {
        let resultArrived = self.expectationWithDescription("result arrived")
        Figo.login(username: username, password: "foo", clientID: clientID, clientSecret: clientSecret) { result in
            switch result {
            case .Success(_):
                XCTFail("Login should have failed")
                break
            case .Failure(let error):
                XCTAssertEqual(error.localizedFailureReason, "Invalid credentials")
                break
            }
            resultArrived.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
        
        // After a failed login we need to login with correct credentials to avoid locking the account
        testThatLoginYieldsAccessToken()
    }
    
    func testThatRetrieveWithoutLoginYieldsCorrectError() {
        let resultArrived = self.expectationWithDescription("result arrived")
        Figo.retrieveAccounts() { result in
            switch result {
            case .Success(_):
                XCTFail("Retrieve should have failed")
                break
            case .Failure(let error):
                XCTAssert(error.localizedFailureReason!.containsString("401 Unauthorized"))
                break
            }
            resultArrived.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    func disabled_testThatLogoutRevokesAccessToken() {
        let resultArrived = self.expectationWithDescription("result arrived")
        Figo.login(username: username, password: password, clientID: clientID, clientSecret: clientSecret) { result in
            XCTAssert(result.isSuccess)
            Figo.logout() { result in
                XCTAssert(result.isSuccess)
                Figo.retrieveAccount("A1.1") { result in
                    XCTAssert(result.isFailure)
                    resultArrived.fulfill()
                }
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }

}