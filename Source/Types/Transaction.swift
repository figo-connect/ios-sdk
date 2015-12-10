//
//  Transaction.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct TransactionListEnvelope: Unboxable {
    
    public let transactions: [Transaction]
    public let deleted: [Transaction]
    public let statistics: [String: AnyObject]
    public let status: SyncStatus
    
    public init(unboxer: Unboxer) {
        transactions = unboxer.unbox("transactions")
        deleted = unboxer.unbox("deleted")
        statistics = unboxer.unbox("statistics")
        status = unboxer.unbox("status")
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
    public let accountNumber: String
    
    /// Transaction amount in cents
    public let amount: Int
    
    /// String representation of the amount
    public var amountFormatted: String {
        currencyFormatter.currencyCode = self.currency
        return currencyFormatter.stringFromNumber(NSNumber(double: Double(amount)/100.0))!
    }
    
    private var currencyFormatter: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "de_DE")
        return formatter
    }
    
    /// Bank code of originator or recipient. This field might be empty if the transaction has no bank code, e.g. interest transactions.
    public let bankCode: String
    
    /// Bank name of originator or recipient. This field might be empty if the transaction has no bank code, e.g. interest transactions.
    public let bankName: String
    
    /// This flag indicates whether the transaction is booked or pending
    public let booked: Bool
    
    /// Booking date
    public let bookingDate: Date

    /// Booking text. This field might be empty if the transaction has no booking text.
    public let bookingText: String
    
    /// Internal creation timestamp on the figo Connect server
    public let creationDate: Date
    
    /// Three-character currency code
    public let currency: String
    
    /// Internal modification timestamp on the figo Connect server
    public let modificationDate: Date
    
    /// Name of originator or recipient
    public let name: String
    
    /// Purpose text. This field might be empty if the transaction has no purpose.
    public let purpose: String
    
    /// Internal figo Connect transaction ID
    public let transactionID: String
    
    /// Transaction type
    public let type: PaymentType
    
    /// Value date
    public let valueDate: Date
    
    /// This flag indicates whether the transaction has already been marked as visited by the user
    public let visited: Bool
    
    /// (optional) Provides more info about the transaction if available, depends on the account type
    public let additionalInfo: [String: AnyObject]?
    
    
    public init(unboxer: Unboxer) {
        accountID = unboxer.unbox("account_id")
        accountNumber = unboxer.unbox("account_number")
        amount = unboxer.unbox("amount")
        bankCode = unboxer.unbox("bank_code")
        bankName = unboxer.unbox("bank_name")
        booked = unboxer.unbox("booked")
        bookingDate = unboxer.unbox("booking_date")
        bookingText = unboxer.unbox("booking_text")
        creationDate = unboxer.unbox("creation_timestamp")
        currency = unboxer.unbox("currency")
        modificationDate = unboxer.unbox("modification_timestamp")
        name = unboxer.unbox("name")
        purpose = unboxer.unbox("purpose")
        transactionID = unboxer.unbox("transaction_id")
        type = unboxer.unbox("type")
        valueDate = unboxer.unbox("value_date")
        visited = unboxer.unbox("visited")
        additionalInfo = unboxer.unbox("additional_info")
    }
    
}
