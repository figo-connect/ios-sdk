//
//  TransactionTests.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class TransactionsTests: BaseTestCaseWithLogin {
    
    func testThatRetrieveTransactionForAccountYieldsNoErrors() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        login() {
            var parameters = RetrieveTransactionsParameters()
            parameters.since = "2015-11-30"

            figo.retrieveTransactionsForAccount("A1182805.4", parameters: parameters) { result in
                if case .success(let envelope) = result {
                    print("Retrieved \(envelope.transactions.count) transactions")
                }
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testThatRetrieveTransactionsYieldsNoErrors() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        
        login() {
            var parameters = RetrieveTransactionsParameters()
            parameters.since = "2015-11-30"
            
            figo.retrieveTransactions(parameters) { result in
                
                XCTAssertNil(result.error)
                if case .success(let envelope) = result {
                    print("Retrieved \(envelope.transactions.count) transactions")
                    for t in envelope.transactions {
                        print("\(t.name) \(t.amountFormatted)")
                    }
                    
                    figo.retrieveTransaction(envelope.transactions.last!.transactionID) { result in
                        
                        XCTAssertNil(result.error)
                        expectation.fulfill()
                    }
                }
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
}
