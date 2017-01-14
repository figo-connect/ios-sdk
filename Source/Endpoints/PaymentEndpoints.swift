//
//  PaymentEndpoints.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public extension FigoClient {
    
    /**
     RETRIEVE PAYMENT PROPOSALS
     
     Provides a address book-like list of proposed wire transfer partners
     
     - Parameter completionHandler: Returns payment proposals or error
     */
    public func retrievePaymentProposals(_ completionHandler: @escaping (FigoResult<[PaymentProposal]>) -> Void) {
        request(.retrievePaymentProposals) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     RETRIEVE PAYMENTS OF ALL ACCOUNTS
     
     - Parameter completionHandler: Returns payments or error
     */
    public func retrievePayments(_ completionHandler: @escaping (FigoResult<[Payment]>) -> Void) {
        request(.retrievePayments) { response in
            let unboxingResult: FigoResult<PaymentListEnvelope> = decodeUnboxableResponse(response)
            
            switch unboxingResult {
            case .success(let envelope):
                completionHandler(.success(envelope.payments))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE PAYMENTS OF ONE ACCOUNT
     
     - Parameter completionHandler: Returns payments or error
     */
    public func retrievePaymentsForAccount(_ accountID: String, _ completionHandler: @escaping (FigoResult<[Payment]>) -> Void) {
        request(.retrievePaymentsForAccount(accountID)) { response in
            let unboxingResult: FigoResult<PaymentListEnvelope> = decodeUnboxableResponse(response)
            
            switch unboxingResult {
            case .success(let envelope):
                completionHandler(.success(envelope.payments))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE A PAYMENT
     
     - Parameter paymentID: Internal figo connect ID of the payment
     - Parameter accountID: Internal figo connect ID of the account
     - Parameter completionHandler: Returns payments or error
     */
    public func retrievePayment(_ paymentID: String, accountID: String, _ completionHandler: @escaping (FigoResult<Payment>) -> Void) {
        request(.retrievePayment(paymentID, accountID: accountID)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     CREATE A SINGLE PAYMENT
     
     - Parameter parameters: `CreatePaymentParameters`
     - Parameter completionHandler: Returns payment or error
     */
    public func createPayment(_ parameters: CreatePaymentParameters, _ completionHandler: @escaping (FigoResult<Payment>) -> Void) {
        request(.createPayment(parameters)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     MODIFY A PAYMENT
     
     - Parameter payment: `Payment`
     - Parameter completionHandler: Returns nothing or error
     */
    public func modifyPayment(_ payment: Payment, _ completionHandler: @escaping (FigoResult<Payment>) -> Void) {
        request(.modifyPayment(payment)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     SUBMIT PAYMENT
     
     - Parameter payment: `Payment`
     - Parameter tanSchemeID: TAN scheme ID of user-selected TAN scheme
     - Parameter pinHandler: Is called when the server needs a PIN
     - Parameter challengeHandler: Is called when the server needs a response to a challenge
     - Parameter completionHandler: Returns nothing or error
     */
    public func submitPayment(_ payment: Payment, tanSchemeID: String, pinHandler: @escaping PinResponder, challengeHandler: @escaping ChallengeResponder, _ completionHandler: @escaping VoidCompletionHandler) {
        request(.submitPayment(payment, tanSchemeID: tanSchemeID)) { response in
            
            let unboxingResult: FigoResult<TaskTokenEvelope> = decodeUnboxableResponse(response)
            switch unboxingResult {
            case .success(let envelope):
                
                let nextParameters = PollTaskStateParameters(taskToken: envelope.taskToken)
                self.pollTaskState(nextParameters, POLLING_COUNTDOWN_INITIAL_VALUE, nil, pinHandler, challengeHandler) { result in
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
