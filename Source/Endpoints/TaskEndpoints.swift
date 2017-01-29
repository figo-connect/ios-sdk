//
//  TaskEndpoints.swift
//  Figo
//
//  Created by Christian König on 28.11.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//

import Foundation


public extension FigoClient {
    
    fileprivate func delay(_ block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(POLLING_INTERVAL_MSECS) / Double(NSEC_PER_SEC), execute: {
            block()
        })
    }
    
    /**
     POLL TASK STATE
     
     While the figo Connect server communicates with a bank server, the framework in monitoring its progress by periodically polling the task state.
     
     - Parameter parameters: PollTaskStateParameters
     - Parameter countdown: A counter utilized to implement a polling timeout
     - Parameter progressHandler: (optional) Is called periodically with a message from the server
     - Parameter pinHandler: Is called when the server needs a PIN
     - Parameter challengeHandler: Is called when the server needs a response to a challenge
     - Parameter completionHandler: Is called on completion returning nothing or error
     */
    internal func pollTaskState(_ parameters: PollTaskStateParameters, _ countdown: Int, _ progressHandler: ProgressUpdate? = nil, _ pinHandler: PinResponder?, _ challengeHandler: ChallengeResponder?, _ completionHandler: @escaping VoidCompletionHandler) {
        guard countdown > 0 else {
            completionHandler(.failure(FigoError(error: .taskProcessingTimeout)))
            return
        }

        request(Endpoint.pollTaskState(parameters)) { responseData in
            let decoded: FigoResult<TaskState> = decodeUnboxableResponse(responseData)
            
            switch decoded {
            case .failure(let error):
                
                completionHandler(.failure(error))
                break
            case .success(let state):
                
                if let progressHandler = progressHandler {
                    progressHandler(state.message)
                }
                
                if state.isErroneous {
                    if let error = state.error {
                        completionHandler(.failure(error))
                    } else {
                        completionHandler(.failure(FigoError(error: .taskProcessingError(accountID: state.accountID, message: state.message))))
                    }
                }
                    
                else if state.isEnded {
                    completionHandler(.success())
                }
                    
                else if state.isWaitingForPIN {
                    guard let pinHandler = pinHandler else {
                        completionHandler(.failure(FigoError(error: .internalError(reason: "No PinResponder"))))
                        return
                    }
                    
                    let pin = pinHandler(state.message, state.accountID)
                    let nextParameters = PollTaskStateParameters(taskToken: parameters.taskToken, pin: pin.pin, savePin: pin.savePin)
                    self.pollTaskState(nextParameters, countdown - 1, progressHandler, pinHandler, challengeHandler, completionHandler)
                }
                    
                else if state.isWaitingForResponse {
                    guard let challengeHandler = challengeHandler else {
                        completionHandler(.failure(FigoError(error: .internalError(reason: "No ChallengeResponder"))))
                        return
                    }
                    guard let challenge = state.challenge else {
                        completionHandler(.failure(FigoError(error: .internalError(reason: "Server is waiting for response but has not given a challenge"))))
                        return
                    }
                    
                    let response = challengeHandler(state.message, state.accountID, challenge)
                    let nextParameters = PollTaskStateParameters(taskToken: parameters.taskToken, response: response)
                    self.pollTaskState(nextParameters, countdown - 1, progressHandler, pinHandler, challengeHandler, completionHandler)
                }

                else {
                    self.delay() {
                        let nextParameters = PollTaskStateParameters(taskToken: parameters.taskToken)
                        self.pollTaskState(nextParameters, countdown - 1, progressHandler, pinHandler, challengeHandler, completionHandler)
                    }
                }
                break
            }
        }
    }
    
    
    /**
     CREATE NEW SYNCHRONIZATION TASK
     
     In order for figo to have up-to-date transaction and account information, it needs to query the bank servers, which is called synchronization. With this call you can create a new task, synchronizing all (or the specified) accounts with the state returned by the bank.
     
     - Parameter parameters: (optional) CreateSyncTaskParameters
     - Parameter progressHandler: (optional) Is called periodically with a message from the server
     - Parameter pinHandler: Is called when the server needs a PIN
     - Parameter completionHandler: Is called on completion returning nothing or error
     */
    public func synchronize(parameters: CreateSyncTaskParameters = CreateSyncTaskParameters(), progressHandler: ProgressUpdate? = nil, pinHandler: @escaping PinResponder, completionHandler: @escaping VoidCompletionHandler) {
        request(.synchronize(parameters.JSONObject)) { response in
            
            let unboxingResult: FigoResult<TaskTokenEvelope> = decodeUnboxableResponse(response)
            switch unboxingResult {
            case .success(let envelope):
                
                let nextParameters = PollTaskStateParameters(taskToken: envelope.taskToken)
                self.pollTaskState(nextParameters, POLLING_COUNTDOWN_INITIAL_VALUE, progressHandler, pinHandler, nil) { result in
                    completionHandler(result)
                }
                break
            case .failure(let error):
                
                completionHandler(.failure(error))
                break
            }
        }
    }
    
}




