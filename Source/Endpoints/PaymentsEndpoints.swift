//
//  PaymentsEndpoints.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


extension FigoSession {
    
    /**
     RETRIEVE PAYMENT PROPOSALS
     
     Provides a address book-like list of proposed wire transfer partners
     
     - Parameter completionHandler: Returns payment proposals or error
     */
    public func retrievePaymentProposals(completionHandler: FigoResult<[PaymentProposal]> -> Void) {
        request(.RetrievePaymentProposals) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     RETRIEVE PAYMENTS OF ALL ACCOUNTS
     
     - Parameter completionHandler: Returns payments or error
     */
    public func retrievePayments(completionHandler: FigoResult<[Payment]> -> Void) {
        request(.RetrievePayments) { response in
            let unboxingResult: FigoResult<PaymentListEnvelope> = decodeUnboxableResponse(response)
            
            switch unboxingResult {
            case .Success(let envelope):
                completionHandler(.Success(envelope.payments))
                break
            case .Failure(let error):
                completionHandler(.Failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE PAYMENTS OF ONE ACCOUNT
     
     - Parameter completionHandler: Returns payments or error
     */
    public func retrievePaymentsForAccount(accountID: String, _ completionHandler: FigoResult<[Payment]> -> Void) {
        request(.RetrievePaymentsForAccount(accountID)) { response in
            let unboxingResult: FigoResult<PaymentListEnvelope> = decodeUnboxableResponse(response)
            
            switch unboxingResult {
            case .Success(let envelope):
                completionHandler(.Success(envelope.payments))
                break
            case .Failure(let error):
                completionHandler(.Failure(error))
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
    public func retrievePayment(paymentID: String, accountID: String, _ completionHandler: FigoResult<Payment> -> Void) {
        request(.RetrievePayment(paymentID, accountID: accountID)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     CREATE A SINGLE PAYMENT
     
     - Parameter parameters: `CreatePaymentParameters`
     - Parameter completionHandler: Returns payment or error
     */
    public func createPayment(parameters: CreatePaymentParameters, _ completionHandler: FigoResult<Payment> -> Void) {
        request(.CreatePayment(parameters)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     MODIFY A PAYMENT
     
     - Parameter payment: `Payment`
     - Parameter completionHandler: Returns nothing or error
     */
    public func modifyPayment(payment: Payment, _ completionHandler: FigoResult<Payment> -> Void) {
        request(.ModifyPayment(payment)) { response in
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
    public func submitPayment(payment: Payment, tanSchemeID: String, pinHandler: PinResponder, challengeHandler: ChallengeResponder, _ completionHandler: VoidCompletionHandler) {
        request(.SubmitPayment(payment, tanSchemeID: tanSchemeID)) { response in
            
            let unboxingResult: FigoResult<TaskTokenEvelope> = decodeUnboxableResponse(response)
            switch unboxingResult {
            case .Success(let envelope):
                
                let nextParameters = PollTaskStateParameters(taskToken: envelope.taskToken)
                self.pollTaskState(nextParameters, self.POLLING_COUNTDOWN_INITIAL_VALUE, nil, pinHandler, challengeHandler) { result in
                    completionHandler(result)
                }
                break
            case .Failure(let error):
                
                completionHandler(.Failure(error))
                break
            }
        }
    }
}
