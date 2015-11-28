//
//  UserTests.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class UserTests: BaseTestCaseWithLogin {
    
    func testThatRetrieveCurrentUserYieldsObject() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        login() {
            self.figo.retrieveCurrentUser() { user, error in
                if let user = user {
                    XCTAssertEqual(user.email, "christian@koenig.systems")
                }
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testCreateUser() {
        let user = CreateUserParameters(name: username, email: username, password: password, send_newsletter: false, language: "de", affiliate_user: nil, affiliate_client_id: nil)
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        figo.createNewFigoUser(user, clientID: "", clientSecret: "") { (recoveryPassword, error) -> Void in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    func testDeleteUser() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        login() {
            self.figo.deleteCurrentUser({ (result) -> Void in
                XCTAssertNil(result.error)
                expectation.fulfill()
            })
        }
        self.waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    
}