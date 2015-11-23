//
//  Figo_iOS_Tests.swift
//  Figo iOS Tests
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Alamofire
@testable import Figo


class BaseTestCase: XCTestCase {
    
    let username = "christian@koenig.systems"
    let password = "eVPVdiL7a8EUAP"
    let clientID = "C3XGp3LGISZFwJSsDfxwhHvXT1MjCoF92lOJ3VZrKeBI"
    let clientSecret = "SJtBMNCn6KrIkjQSCkV-xU3_ob0sUTHAFLy-K1V86SpY"
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testLoginUser() {
        let resultArrived = self.expectationWithDescription("result arrived")
        
        Figo.login(username: username, password: password, clientID: clientID, clientSecret: clientSecret) { result in
            
            switch result {
            case .Success(let authorization):
                XCTAssertNotNil(authorization.access_token)
                break
            case .Failure(let error):
                XCTFail(error.localizedFailureReason ?? "no failure reason was provided")
                break
            }

            resultArrived.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testRetrieveAccounts() {
        let resultArrived = self.expectationWithDescription("result arrived")
        
        Figo.login(username: username, password: password, clientID: clientID, clientSecret: clientSecret) { result in
            Figo.retrieveAccounts() { result in
                
                switch result {
                case .Success(let accounts):
                    XCTAssertGreaterThan(accounts.count, 0)
                    break
                case .Failure(let error):
                    XCTFail(error.localizedFailureReason ?? "no failure reason was provided")
                    break
                }
                
                resultArrived.fulfill()
            }
        }
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }

    
    func testRetrieveAccount() {
        let resultArrived = self.expectationWithDescription("result arrived")
        
        Figo.login(username: username, password: password, clientID: clientID, clientSecret: clientSecret) { result in
            Figo.retrieveAccount("A1079434.13") { result in
                
                switch result {
                case .Success(let account):
                    XCTAssertEqual(account.account_number!, "743668")
                    break
                case .Failure(let error):
                    XCTFail(error.localizedFailureReason ?? "no failure reason was provided")
                    break
                }
                
                
                resultArrived.fulfill()
            }
        }
        
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
}
