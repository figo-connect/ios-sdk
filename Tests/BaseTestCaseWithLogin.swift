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


let figo = FigoClient(logger: ConsoleLogger())


class BaseTestCaseWithLogin: XCTestCase {
    
    let username = "christian@koenig.systems"
    let password = "eVPVdiL7"
    let clientID = "C3XGp3LGISZFwJSsDfxwhHvXT1MjCoF92lOJ3VZrKeBI"
    let clientSecret = "SJtBMNCn6KrIkjQSCkV-xU3_ob0sUTHAFLy-K1V86SpY"

    let demoGiroAccountId = "A2132899.1"
    let demoGiroAccountTANSchemeId = "M2132899.1"
    let demoSavingsAccountId = "A2132899.2"
    let demoDepotId = "A2132899.3"
    
    var refreshToken: String?
    
    override class func setUp() {
        super.setUp()
    }
    
    func login(_ completionHandler: @escaping () -> Void) {
        guard refreshToken == nil else {
            debugPrint("Active session, skipping Login")
            completionHandler()
            return
        }
        debugPrint("Begin Login")
        figo.loginWithUsername(username, password: password, clientID: clientID, clientSecret: clientSecret) { refreshToken in
            self.refreshToken = refreshToken.value
            XCTAssertNotNil(refreshToken.value)
            XCTAssertNil(refreshToken.error)
            debugPrint("End Login")
            completionHandler()
        }
    }
    
    func logout(_ completionHandler: @escaping () -> Void) {
        guard refreshToken != nil else {
            debugPrint("No active session, skipping Logout")
            completionHandler()
            return
        }
        debugPrint("Begin Logout")
        figo.revokeRefreshToken(self.refreshToken!) { result in
            XCTAssertNil(result.error)
            debugPrint("End Logout")
            completionHandler()
        }
    }
}
