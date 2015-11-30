//
//  TaskEndpoints.swift
//  Figo
//
//  Created by Christian König on 28.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation

public typealias ProgressUpdate = (message: String) -> Void
public typealias PinResponder = (message: String, accountID: String) -> String
public typealias ChallengeResponder = (message: String, accountID: String, challenge: Challenge) -> String

public typealias CompletionHandler = (error: FigoError?) -> Void



extension FigoSession {
    
    private func delay(block: () -> Void) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, POLLING_INTERVAL_MSECS), dispatch_get_main_queue(), {
            block()
        })
    }
    
    
    
    /**
     POLL TASK STATE
     
     While the figo Connect server communicates with a bank server, your application can monitor its progress by periodically polling this method
     */
    func pollTaskState(token: String, _ countdown: Int, _ completionHandler: VoidCompletionHandler) {
        guard countdown > 0 else {
            completionHandler(.Failure(.TaskProcessingTimeout))
            return
        }
        let parameters = PollTaskStateParameters(id: token, pin: nil, continueAfterError: nil, savePin: nil, response: nil)
        request(Endpoint.PollTaskState(parameters)) { response in
            let decoded: FigoResult<TaskState> = responseUnboxed(response)
            switch decoded {
            case .Failure(let error):
                completionHandler(.Failure(error))
                break
            case .Success(let state):
                if state.is_ended {
                    if state.is_erroneous {
                        completionHandler(.Failure(.TaskProcessingError(accountID: state.account_id, message: state.message)))
                    } else {
                        completionHandler(.Success())
                    }
                } else {
                    print(state.message)
                    self.delay() {
                        self.pollTaskState(token, countdown - 1, completionHandler)
                    }
                }
                break
            }
        }
    }
    
}
