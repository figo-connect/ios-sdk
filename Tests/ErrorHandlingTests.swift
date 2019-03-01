//
//  ErrorHandlingTests.swift
//  Figo
//
//  Created by Christian König on 14.01.17.
//  Copyright © 2017 figo GmbH. All rights reserved.
//

import XCTest
import Figo


class ErrorHandlingTests: BaseTestCaseWithLogin {
    
    func testInvalidUsername() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        figo.loginWithUsername("foo", password: "bar") { result in
            if case .success = result {
                XCTFail()
            }
            if case .failure(let error) = result {
                XCTAssertEqual(error.code, 90000)
                XCTAssertEqual(error.description, "Username not found")
            }
            
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testInvalidPassword() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        figo.loginWithUsername(username, password: "foo") { result in
            if case .success = result {
                XCTFail()
            }
            if case .failure(let error) = result {
                XCTAssertEqual(error.code, 90000)
                XCTAssertEqual(error.description, "Invalid credentials")
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testInvalidClientID() {
        let figo = FigoClient(clientID: "123", clientSecret: clientSecret, logger: ConsoleLogger())
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        figo.loginWithUsername(username, password: password) { result in
            if case .success = result {
                XCTFail()
            }
            if case .failure(let error) = result {
                XCTAssertEqual(error.code, 90000)
                XCTAssertEqual(error.description, "invalid client")
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testInvalidClientSecret() {
        let figo = FigoClient(clientID: clientID, clientSecret: "123", logger: ConsoleLogger())
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        figo.loginWithUsername(username, password: password) { result in
            if case .success = result {
                XCTFail()
            }
            if case .failure(let error) = result {
                XCTAssertEqual(error.code, 500)
                XCTAssertEqual(error.description, "Internal server error")
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testInvalidBankingCredentials() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        figo.loginWithUsername(username, password: password) { result in
            if case .success = result {
                let account = CreateAccountParameters(bankCode: "66450050", iban: nil, credentials: ["foo2", "bar"], savePin: false)
                
                figo.setupNewBankAccount(account) { result in
                    if case .success = result {
                        XCTFail()
                    }
                    if case .failure(let error) = result {
                        XCTAssertGreaterThan(error.code, 0)
                        XCTAssertGreaterThan(error.description.count, 0)
                        XCTAssertGreaterThan(error.message?.count ?? 0, 0)
                    }
                    
                    expectation.fulfill()
                }
            }
            if case .failure = result {
                expectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    

}
