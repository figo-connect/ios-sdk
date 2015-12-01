//
//  TaskTests.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class TaskTests: BaseTestCaseWithLogin {
    
    func testThatSynchronizeYieldsNoErrors() {
        let expectation = self.expectationWithDescription("Wait for all asyc calls to return")

        login() {
            
            let progressHandler: ProgressUpdate = { message in
                print(message)
            }
            
            let pinHandler: PinResponder = { message, accountID in
                print("\(message) (\(accountID))")
                return (pin: "demo", savePin: true)
            }

            let parameters = CreateSyncTaskParameters(ifNotSyncedSince: nil, autoContinue: false, accountIDs: nil, syncTasks: nil)
            
            self.figo.synchronize(parameters: parameters, progressHandler: progressHandler, pinHandler: pinHandler) { result in
                XCTAssertNil(result.error)
                expectation.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
}