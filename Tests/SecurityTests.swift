//
//  SecurityTests.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class SecurityTests: BaseTestCaseWithLogin {
    
    func testThatRetrieveSecuritiesForAccountYieldsNoErrors() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        login() {

            figo.retrieveSecuritiesForAccount("A1182805.4") { result in
                if case .success(let envelope) = result {
                    print("Retrieved \(envelope.securities.count) securities")
                }
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testThatRetrieveSecuritiesYieldsNoErrors() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        login() {
            figo.retrieveSecurities() { result in
                if case .success(let envelope) = result {
                    print("Retrieved \(envelope.securities.count) securities")
                    for s in envelope.securities {
                        print("\(s.name) (current price: \(s.priceFormatted))")
                    }
                }
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testThatRetrieveSecurityYieldsNoErrors() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        login() {
            
            figo.retrieveSecurity("S1182805.2", accountID: "A1182805.3") { result in
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
}
