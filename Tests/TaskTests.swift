//
//  TaskTests.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//

import XCTest
import Figo


class TaskTests: BaseTestCaseWithLogin {
    
    func testThatSynchronizeYieldsNoErrors() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")

        login() {
            
            let progressHandler: ProgressUpdate = { message in
                print(message)
            }
            
            let pinHandler: PinResponder = { message, accountID in
                print("\(message) (\(accountID))")
                return (pin: "demo", savePin: true)
            }

            let parameters = CreateSyncTaskParameters(ifNotSyncedSince: nil, autoContinue: false, accountIDs: nil, syncTasks: nil)
            
            figo.synchronize(parameters: parameters, progressHandler: progressHandler, pinHandler: pinHandler) { result in
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
}
