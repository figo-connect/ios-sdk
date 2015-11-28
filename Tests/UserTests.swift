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
    
    func testThatUserSerializerYieldsObject() {
        let JSONObject = Resources.User.JSONObject
        let user = try! User(representation: JSONObject)
        
        XCTAssertEqual(user.address?.city, "Berlin")
        XCTAssertEqual(user.address?.company, "figo")
        XCTAssertEqual(user.address?.postal_code, "10969")
        XCTAssertEqual(user.address?.street, "Ritterstr. 2-3")
        XCTAssertEqual(user.email, "demo@figo.me")
        XCTAssertEqual(user.join_date, "2012-04-19T17:25:54.000Z")
        XCTAssertEqual(user.language, "en")
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.premium, true)
        XCTAssertEqual(user.premium_expires_on, "2014-04-19T17:25:54.000Z")
        XCTAssertEqual(user.premium_subscription, "paymill")
        XCTAssertEqual(user.send_newsletter, true)
        XCTAssertEqual(user.user_id, "U12345")
        XCTAssertEqual(user.verified_email, true)
    }
    
    func testCreateCreateUserParameters() {
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