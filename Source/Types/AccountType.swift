//
//  AccountType.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public enum AccountType: String, UnboxableEnum {

    case GiroAccount = "Giro account"
    case SavingsAccount = "Savings account"
    case CreditCard = "Credit card"
    case LoanAccount = "Loan account"
    case PayPal = "PayPal"
    case CashBook = "Cash book"
    case Depot = "Depot"
    case Unknown = "Unknown"

    static func unboxFallbackValue() -> AccountType {
        return .Unknown
    }
    
}

