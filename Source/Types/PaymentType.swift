//
//  PaymentType.swift
//  Figo
//
//  Created by Christian König on 26.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public enum PaymentType: String {
    case Transfer = "Transfer"
    case DirectDebit = "Direct debit"
    case SEPATransfer = "SEPA transfer"
    case SEPADirectDebit = "SEPA direct debit"
}
