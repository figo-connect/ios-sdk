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

    override func setUp() {
        super.setUp()
        
        guard !Figo.isUserLoggedIn else { return }
        
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        Figo.login(username: username, password: password, clientID: clientID, clientSecret: clientSecret) { authorization, error in
            XCTAssertNotNil(authorization?.access_token)
            XCTAssertNil(error)
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
}