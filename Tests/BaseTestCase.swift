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
    
    let username = "demo@figo.me"
    let password = "demo1234"
    let clientID = "CaESKmC8MAhNpDe5rvmWnSkRE_7pkkVIIgMwclgzGcQY"
    let clientSecret = "STdzfv0GXtEj_bwYn7AgCVszN1kKq5BdgEIKOM_fzybQ"
    
    
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
    

}
