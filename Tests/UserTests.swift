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
            figo.retrieveCurrentUser() { result in
                if let user = result.value {
                    XCTAssertEqual(user.email, "christian@koenig.systems")
                }
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testCreateAndDeleteUser() {
        let username = "hi@chriskoenig.de"
        let password = "eVPVdiL7"
        let params = CreateUserParameters(name: username, email: username, password: password, send_newsletter: false, language: "de", affiliate_user: nil, affiliateClientID: nil)
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        
        figo.createNewFigoUser(params, clientID: clientID, clientSecret: clientSecret) { result in
            XCTAssertNil(result.error)
            
            figo.loginWithUsername(username, password: password, clientID: self.clientID, clientSecret: self.clientSecret) { refreshToken in
                XCTAssertNil(refreshToken.error)
                
                figo.deleteCurrentUser({ (result) -> Void in
                    XCTAssertNil(result.error)
                    expectation.fulfill()
                })
            }
        }
        
        self.waitForExpectationsWithTimeout(60, handler: nil)
    }
}