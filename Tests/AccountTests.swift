//
//  AccountTests.swift
//  Figo iOS Tests
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//

import XCTest
@testable import Figo


class AccountTests: BaseTestCaseWithLogin {
    
    func testThatRetrieveAccountsYieldsObjects() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            figo.retrieveAccounts() { result in
                switch result {
                case .success(let accounts):
                    XCTAssertGreaterThan(accounts.count, 0)
                    print("\(accounts.count) accounts:")
                    for account in accounts {
                        print("\(account.accountID) \(account.bankID ?? "null") \(account.bankCode) \(account.name) \(account.balanceFormatted ?? "")")
                    }
                    break
                case .failure(let error):
                    XCTFail(error.description)
                    break
                }
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testThatRetrieveAccountYieldsObject() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            figo.retrieveAccount(self.demoGiroAccountId) { result in
                XCTAssertNil(result.error)
                if let account = result.value {
                    XCTAssertEqual(account.accountNumber, "4711951500")
                }
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testRemovePin() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            figo.removeStoredPinFromBankContact(self.demoUserId) { result in
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func disabled_testSetupAccount() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            let account = CreateAccountParameters(bankCode: self.demoBankCode, iban: nil, credentials: self.demoCredentials, savePin: false)
            figo.setupNewBankAccount(account) { result in
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func disabled_testDeleteBankAccount() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            figo.retrieveAccounts() { result in
                XCTAssertNil(result.error)
                
                figo.deleteAccount(result.value!.last!.accountID) { result in
                    XCTAssertNil(result.error)
                    expectation.fulfill()
                }
            }

        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    

    
}
