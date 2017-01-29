//
//  PaymentTests.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//

import XCTest
import Figo


class PaymentTests: BaseTestCaseWithLogin {
    
    func testThatRetrievePaymentsYieldsNoErrors() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        login() {
            figo.retrievePayments() { result in
                if case .success(let payments) = result {
                    print("Retrieved \(payments.count) payments")
                    for p in payments {
                        print("\(p.name) \(p.amountFormatted)")
                    }
                }
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    
    func testThatRetrievePaymentsForAccountYieldsNoErrors() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        login() {
            figo.retrievePaymentsForAccount(self.demoGiroAccountId) { result in
                XCTAssertNil(result.error)
                if case .success(let payments) = result {
                    print("Retrieved \(payments.count) payments")
                    XCTAssertGreaterThan(payments.count, 0)
                    if let lastPayment = payments.last {
                        figo.retrievePayment(lastPayment.paymentID, accountID: self.demoGiroAccountId) { result in
                            XCTAssertNil(result.error)
                        }
                    }
                    expectation.fulfill()
                }
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }


    
    func testCreateModifyAndSubmitPayment() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        var params = CreatePaymentParameters(accountID: self.demoGiroAccountId, type: .Transfer, name: "Christian König", amount: 222, purpose: "Test")
        params.bankCode = "90090042"
        params.accountNumber = "4711951501"
        
        let pinHandler: PinResponder = { message, accountID in
            print("\(message) (\(accountID))")
            return (pin: "demo", savePin: true)
        }
        
        let challengeHandler: ChallengeResponder = { message, accountID, challenge in
            print("\(message) (\(accountID))")
            print(challenge)
            return "111111"
        }
        
        login() {
            
            figo.createPayment(params) { createResult in
                switch createResult {
                    
                case .success(var payment):
                    payment.amount = 666
                    
                    figo.modifyPayment(payment) { modifyResult in
                        switch modifyResult {
                            
                        case .success(let payment):
                            figo.submitPayment(payment, tanSchemeID: self.demoGiroAccountTANSchemeId, pinHandler: pinHandler, challengeHandler: challengeHandler) { submitResult in
                                XCTAssertNil(submitResult.error)
                                expectation.fulfill()
                            }
                            break
                            
                        case .failure(let error):
                            XCTAssertNil(error)
                            expectation.fulfill()
                            break
                        }
                    }
                    break
                    
                case .failure(let error):
                    XCTAssertNil(error)
                    expectation.fulfill()
                    break
                }
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    
}

