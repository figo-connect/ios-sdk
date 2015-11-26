//
//  CreateNewUserTests.swift
//  Figo
//
//  Created by Christian König on 26.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import XCTest
import Figo


class CreateNewUserTests: XCTestCase {

    let clientID = "C3XGp3LGISZFwJSsDfxwhHvXT1MjCoF92lOJ3VZrKeBI"
    let clientSecret = "SJtBMNCn6KrIkjQSCkV-xU3_ob0sUTHAFLy-K1V86SpY"
    
    func xtestCreateNewUser() {

        let user = NewUser(name: "Christian König", email: "christian@koenig.systems", password: "b2D59>497'TL", send_newsletter: false, language: "de", affiliate_user: nil, affiliate_client_id: nil)

        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        createNewFigoUser(user, clientID: clientID, clientSecret: clientSecret) { (recoveryPassword, error) -> Void in
            XCTAssertNil(error)
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
        
    }
}


