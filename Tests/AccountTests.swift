//
//  Figo_iOS_Tests.swift
//  Figo iOS Tests
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class AccountTests: BaseTestCaseWithLogin {
    
    let demoBankCode = "90090042"
    let demoCredentials = ["demo", "demo"]
    
    func testShowsSimplestRetrieveAccountsCallWithoutErrorHandling() {
        login()
        let callbackExpectation = self.expectationWithDescription("callback has been executed")
        figo.retrieveAccounts() { accounts, _ in
            if let accounts = accounts {
                XCTAssertGreaterThan(accounts.count, 0)
            }
            callbackExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
        logout()
    }
    
//    func testThatRetrieveAccountsYieldsObjects() {
//        login()
//        let callbackExpectation = self.expectationWithDescription("callback has been executed")
//        Figo.retrieveAccounts() { accounts, error in
//            if let accounts = accounts {
//                XCTAssertGreaterThan(accounts.count, 0)
//            }
//            XCTAssertNil(error)
//            callbackExpectation.fulfill()
//        }
//        self.waitForExpectationsWithTimeout(30, handler: nil)
//        logout()
//    }
//    
//    func testThatRetrieveAccountYieldsObject() {
//        login()
//        let callbackExpectation = self.expectationWithDescription("callback has been executed")
//        Figo.retrieveAccount("A1079434.5") { account, error in
//            XCTAssertNil(error)
//            if let account = account {
//                XCTAssertEqual(account.account_number, "1146174")
//                XCTAssertNil(error)
//                callbackExpectation.fulfill()
//            }
//        }
//        self.waitForExpectationsWithTimeout(30, handler: nil)
//        logout()
//    }
//    
//    func testRemovePin() {
//        login()
//        let callbackExpectation = self.expectationWithDescription("callback has been executed")
//        Figo.removeStoredPinFromBankContact("B1079434.3") { error in
//            XCTAssertNil(error)
//            callbackExpectation.fulfill()
//        }
//        self.waitForExpectationsWithTimeout(30, handler: nil)
//        logout()
//    }
//    
//    func testErrorHandlingWithNoContentResponse() {
//
//        let callbackExpectation = self.expectationWithDescription("callback has been executed")
//        Figo.removeStoredPinFromBankContact("B1079434.3") { error in
//            XCTAssertNotNil(error)
//            callbackExpectation.fulfill()
//        }
//        self.waitForExpectationsWithTimeout(30, handler: nil)
//
//    }
//    
//    func testSetupNewAccount() {
//        login()
//        let callbackExpectation = self.expectationWithDescription("callback has been executed")
//        let account = NewAccount(bank_code: self.demoBankCode, iban: nil, credentials: self.demoCredentials, save_pin: true, disable_first_sync: nil, sync_tasks: nil)
//        setupNewBankAccount(account) { error in
//            XCTAssertNil(error)
//            callbackExpectation.fulfill()
//        }
//        self.waitForExpectationsWithTimeout(30, handler: nil)
//        logout()
//    }
    

}