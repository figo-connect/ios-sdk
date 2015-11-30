//
//  SupportedPayment.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public enum SupportedPayment {
    
    case Transfer(parameters: PaymentParameters)
    case DirectDebit(parameters: PaymentParameters)
    case SEPATransfer(parameters: PaymentParameters)
    case SEPADirectDebit(parameters: PaymentParameters)
    
    init(rawValue: String, parameters: PaymentParameters) {
        switch rawValue {
        case "Transfer":
            self = .Transfer(parameters: parameters)
            break
        case "Direct debit":
            self = .DirectDebit(parameters: parameters)
            break
        case "SEPA transfer":
            self = .SEPATransfer(parameters: parameters)
            break
        case "SEPA direct debit":
            self = .SEPADirectDebit(parameters: parameters)
            break
        default:
            self = .Transfer(parameters: parameters)
            break
        }
    }
}