//
//  AccountTests.swift
//  Figo iOS Tests
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
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
                        print("\(account.accountID) \(account.bankID) \(account.bankCode) \(account.name) \(account.balanceFormatted ?? "")")
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
    
    
    func testRetrieveLoginSettings() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            figo.retrieveLoginSettings(bankCode: "20090500") { result in
                XCTAssertNil(result.error)
                if case .success(let settings) = result {
                    XCTAssertTrue(settings.supported)
                    XCTAssertEqual(settings.authType, "pin")
                }
                
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }

    func testSupportedBanksUnboxing() {
        let data = Resources.SupportedBanks.data
        do {
            let envelope: BanksListEnvelope = try unbox(data: data)
            XCTAssertEqual(envelope.banks.first!.bankCode, 10000000)
            
        } catch (let error) {
            XCTAssertNil(error)
        }
    }
    
    func disabled_testRetrieveSupportedBanks() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            figo.retrieveSupportedBanks() { result in
                XCTAssertNil(result.error)
                if case .success(let banks) = result {
                    let bank = banks.first!
                    debugPrint(bank)
                }
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testRetrieveSupportedServices() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            figo.retrieveSupportedServices() { result in
                XCTAssertNil(result.error)
                if case .success(let services) = result {
                    let service = services.first!
                    debugPrint(service)
                }
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
}
