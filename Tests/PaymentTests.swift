//
//  PaymentTests.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class PaymentTests: BaseTestCaseWithLogin {
    
    func testThatRetrievePaymentsYieldsNoErrors() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        
        login() {
            figo.retrievePayments() { result in
                if case .Success(let payments) = result {
                    print("Retrieved \(payments.count) payments")
                    for p in payments {
                        print("\(p.name) \(p.amountFormatted)")
                    }
                }
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
    func testThatRetrievePaymentsForAccountYieldsNoErrors() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        
        login() {
            figo.retrievePaymentsForAccount("A1182805.4") { result in
                XCTAssertNil(result.error)
                if case .Success(let payments) = result {
                    print("Retrieved \(payments.count) payments")
                    
                    figo.retrievePayment(payments.last!.paymentID, accountID: "A1182805.4") { result in
                        XCTAssertNil(result.error)
                        expectation.fulfill()
                    }
                }
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }


    
    func testCreateModifyAndSubmitPayment() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")
        
        var params = CreatePaymentParameters(accountID: "A1182805.4", type: .Transfer, name: "Christian König", amount: 222, purpose: "Test")
        params.bankCode = "66450050"
        params.accountNumber = "66450050"
        
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
                    
                case .Success(var payment):
                    payment.amount = 666
                    
                    figo.modifyPayment(payment) { modifyResult in
                        switch modifyResult {
                            
                        case .Success(let payment):
                            figo.submitPayment(payment, tanSchemeID: "M1182805.9", pinHandler: pinHandler, challengeHandler: challengeHandler) { submitResult in
                                XCTAssertNil(submitResult.error)
                                expectation.fulfill()
                            }
                            break
                            
                        case .Failure(let error):
                            XCTAssertNil(error)
                            expectation.fulfill()
                            break
                        }
                    }
                    break
                    
                case .Failure(let error):
                    XCTAssertNil(error)
                    expectation.fulfill()
                    break
                }
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    
}

