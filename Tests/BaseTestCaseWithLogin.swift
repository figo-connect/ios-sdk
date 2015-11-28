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
    
    func login(completionHandler: () -> Void) {
        guard refreshToken == nil else {
            debugPrint("Active session, skipping Login")
            completionHandler()
            return
        }
        debugPrint("Begin Login")
        figo.loginWithUsername(username, password: password) { refreshToken, error in
            self.refreshToken = refreshToken
            XCTAssertNotNil(refreshToken)
            XCTAssertNil(error)
            debugPrint("End Login")
            completionHandler()
        }
    }
    
    func logout(completionHandler: () -> Void) {
        guard refreshToken != nil else {
            debugPrint("No active session, skipping Logout")
            completionHandler()
            return
        }
        debugPrint("Begin Logout")
        figo.revokeRefreshToken(self.refreshToken!) { error in
            XCTAssertNil(error)
            debugPrint("End Logout")
            completionHandler()
        }
    }
}