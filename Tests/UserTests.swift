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
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            figo.retrieveCurrentUser() { result in
                if let user = result.value {
                    XCTAssertEqual(user.email, "christian@koenig.systems")
                }
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func disabled_testCreateAndDeleteUser() {
        let username = "hi@chriskoenig.de"
        let password = "eVPVdiL7"
        let params = CreateUserParameters(name: username, email: username, password: password, sendNewsletter: false, language: "de")
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        figo.createNewFigoUser(params) { result in
            XCTAssertNil(result.error)
            
            figo.loginWithUsername(username, password: password) { refreshToken in
                XCTAssertNil(refreshToken.error)
                
                figo.deleteCurrentUser({ (result) -> Void in
                    XCTAssertNil(result.error)
                    expectation.fulfill()
                })
            }
        }
        
        self.waitForExpectations(timeout: 60, handler: nil)
    }
}
