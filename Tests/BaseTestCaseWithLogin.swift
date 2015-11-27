//
//  BaseTestCaseWithLogin.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import XCTest

@testable import Figo


class BaseTestCaseWithLogin: XCTestCase {
    
    let username = "christian@koenig.systems"
    let password = "eVPVdiL7a8EUAP"
    let clientID = "C3XGp3LGISZFwJSsDfxwhHvXT1MjCoF92lOJ3VZrKeBI"
    let clientSecret = "SJtBMNCn6KrIkjQSCkV-xU3_ob0sUTHAFLy-K1V86SpY"

    func login() {
        
        guard Session.sharedInstance.accessToken == nil else { return }
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.loginWithUsername(username, password: password, clientID: clientID, clientSecret: clientSecret) { refreshToken, error in
            XCTAssertNotNil(refreshToken)
            XCTAssertNil(error)
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func logout() {
        
        guard Session.sharedInstance.accessToken == nil else { return }
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.revokeAccessToken { (error) -> Void in
            XCTAssertNil(error)
            XCTAssertNil(Session.sharedInstance.accessToken)
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
        XCTAssertNil(Session.sharedInstance.accessToken)
    }
}