//
//  Transaction.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Unbox


public struct TransactionListEnvelope: Unboxable {
    
    public let transactions: [Transaction]
    public let deleted: [Transaction]
    public let statistics: [String: AnyObject]
    public let status: SyncStatus
    
    public init(unboxer: Unboxer) throws {
        transactions = try unboxer.unbox(key: "transactions")
        deleted = try unboxer.unbox(key: "deleted")
        statistics = try unboxer.unbox(key: "statistics")
        status = try unboxer.unbox(key: "status")
    }
}


/**

 Each bank account has a list of transactions associated with it. The length of this list depends on the bank and time this account has been setup. In general the information provided for each transaction should be roughly similar to the contents of the printed or online transaction statement available from the respective bank. Please note that not all banks provide the same level of detail.

ADDITIONAL TRANSACTION INFO

For PayPal we provide the gross amount and fees of a transaction in an additional_info object. In the future we will add more properties to this object which are depending on the account type.

TRANSACTION TYPE

In order to simplify your analysis of the users transaction, they are pre-categorized into one of the following types: Transfer, Standing order, Direct debit, Salary or rent, * Electronic cash*, GeldKarte, ATM, Charges or interest or Unknown.

PENDING TRANSACTIONS

Some banks provide information on transaction, which have not yet been executed. These transactions are called pending. Figo marks them with the booked flag being false. As soon as the bank reports the execution of these transactions, this flag changes to true. If such a pending transaction fails to execute, it is automatically removed from the transaction list.

- Note: Amounts in cents: YES
 
*/
public struct Transaction: Unboxable {
    
    /// Internal figo Connect account ID
    public let accountID: String
    
    /// Account number of originator or recipient. This field might be empty if the transaction has no account number, e.g. interest transactions.
    public let accountNumber: String?
    
    /// Transaction amount in cents
    public let amount: Int
    
    /// String representation of the amount
    public var amountFormatted: String {
        currencyFormatter.currencyCode = self.currency
        return currencyFormatter.string(from: NSNumber(value: Double(amount)/100.0 as Double))!
    }
    
    fileprivate var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "de_DE")
        return formatter
    }
    
    /// Bank code of originator or recipient. This field might be empty if the transaction has no bank code, e.g. interest transactions.
    public let bankCode: String?
    
    /// Bank name of originator or recipient. This field might be empty if the transaction has no bank code, e.g. interest transactions.
    public let bankName: String?
    
    /// This flag indicates whether the transaction is booked or pending
    public let booked: Bool
    
    /// Booking date
    public let bookingDate: FigoDate?

    /// Booking text. This field might be empty if the transaction has no booking text.
    public let bookingText: String?
    
    /// Internal creation timestamp on the figo Connect server
    public let creationDate: FigoDate
    
    /// Three-character currency code
    public let currency: String
    
    /// Internal modification timestamp on the figo Connect server
    public let modificationDate: FigoDate
    
    /// Name of originator or recipient
    public let name: String?
    
    /// Purpose text. This field might be empty if the transaction has no purpose.
    public let purpose: String?
    
    /// Internal figo Connect transaction ID
    public let transactionID: String
    
    /// Transaction type
    public let type: PaymentType
    
    /// Value date
    public let valueDate: FigoDate
    
    /// This flag indicates whether the transaction has already been marked as visited by the user
    public let visited: Bool
    
    /// (optional) Provides more info about the transaction if available, depends on the account type
    public let additionalInfo: [String: AnyObject]?
    
    
    public init(unboxer: Unboxer) throws {
        accountID = try unboxer.unbox(key: "account_id")
        accountNumber = unboxer.unbox(key: "account_number")
        amount = try unboxer.unbox(key: "amount")
        bankCode = unboxer.unbox(key: "bank_code")
        bankName = unboxer.unbox(key: "bank_name")
        booked = try unboxer.unbox(key: "booked")
        bookingDate = unboxer.unbox(key: "booking_date")
        bookingText = unboxer.unbox(key: "booking_text")
        creationDate = try unboxer.unbox(key: "creation_timestamp")
        currency = try unboxer.unbox(key: "currency")
        modificationDate = try unboxer.unbox(key: "modification_timestamp")
        name = unboxer.unbox(key: "name")
        purpose = unboxer.unbox(key: "purpose")
        transactionID = try unboxer.unbox(key: "transaction_id")
        type = try unboxer.unbox(key: "type")
        valueDate = try unboxer.unbox(key: "value_date")
        visited = try unboxer.unbox(key: "visited")
        additionalInfo = unboxer.unbox(key: "additional_info")
    }
    
}
