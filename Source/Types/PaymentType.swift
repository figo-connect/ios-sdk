//
//  PaymentType.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


/**

Used in `Account` for supported payments and in `Transaction` for type

*/
public enum PaymentType: String, UnboxableEnum {
    
    case Unknown
    case Transfer
    case DirectDebit = "Direct debit"
    case SEPATransfer = "SEPA transfer"
    case SEPADirectDebit = "SEPA direct debit"
    case Interest = "interest"
    case Charges
    case ATM
    case GeldKarte
    case Rent = "rent"
    case StandingOrder = "Standing order"
    case ElectronicCash = "Electronic cash"
    case SEPAStandingOrder = "SEPA standing order"
    case ModifySEPAStandingOrder = "Modify SEPA standing order"
    
}
