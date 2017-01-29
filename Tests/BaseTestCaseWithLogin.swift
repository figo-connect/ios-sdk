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


let figo = FigoClient(clientID: "C3XGp3LGISZFwJSsDfxwhHvXT1MjCoF92lOJ3VZrKeBI", clientSecret: "SJtBMNCn6KrIkjQSCkV-xU3_ob0sUTHAFLy-K1V86SpY", logger: ConsoleLogger(levels: [.verbose, .debug, .error]))


class BaseTestCaseWithLogin: XCTestCase {
    
    let username = "christian@koenig.systems"
    let password = "eVPVdiL7"
    let clientID = "C3XGp3LGISZFwJSsDfxwhHvXT1MjCoF92lOJ3VZrKeBI"
    let clientSecret = "SJtBMNCn6KrIkjQSCkV-xU3_ob0sUTHAFLy-K1V86SpY"

    let demoBankCode = "90090042"
    let demoCredentials = ["demo", "demo"]
    
    let demoGiroAccountId = "A2132899.4"
    let demoGiroAccountTANSchemeId = "M2132899.9"
    let demoSavingsAccountId = "A2132899.5"
    let demoDepotId = "A2132899.6"
    let demoUserId = "B2132899.2"
    let demoSecurityId = "S2132899.4"
    
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
        figo.loginWithUsername(username, password: password) { refreshToken in
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
    
    /// Allows you to get rid of the boilerplate code for async callbacks in test cases
    func waitForCompletionOfTests(tests: (_ doneWaiting: @escaping () -> ()) -> ()) {
        let completionExpectation = self.expectation(description: "Completion should be called")
        tests {
            completionExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testThatCertificateIsPresent() {
        XCTAssertNotNil(figo.publicKey)
    }
}
