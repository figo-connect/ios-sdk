//
//  BaseTestCaseWithLogin.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import XCTest

import Figo


class BaseTestCaseWithLogin: XCTestCase {
    
    let username = "christian@koenig.systems"
    let password = "eVPVdiL7a8EUAP"
    static let clientID = "C3XGp3LGISZFwJSsDfxwhHvXT1MjCoF92lOJ3VZrKeBI"
    static let clientSecret = "SJtBMNCn6KrIkjQSCkV-xU3_ob0sUTHAFLy-K1V86SpY"

    let figo = FigoSession.init(clientIdentifier: clientID, clientSecret: clientSecret)
    var refreshToken: String?
    
    func login() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        figo.loginWithUsername(username, password: password) { refreshToken, error in
            self.refreshToken = refreshToken
            XCTAssertNotNil(refreshToken)
            XCTAssertNil(error)
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func logout() {
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        figo.revokeRefreshToken(refreshToken!) { error in
            XCTAssertNil(error)
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
}