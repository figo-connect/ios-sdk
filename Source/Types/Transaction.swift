//
//  Transaction.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//



public struct TransactionListEnvelope: Unboxable {
    
    public let transactions: [Transaction]
    public let deleted: [Transaction]
    public let statistics: [String: AnyObject]
    public let status: SyncStatus
    
    init(unboxer: Unboxer) {
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

*/
public struct Transaction: Unboxable {
    
    /// Internal figo Connect account ID
    public let account_id: String
    
    /// Account number of originator or recipient. This field might be empty if the transaction has no account number, e.g. interest transactions.
    public let account_number: String
    
    /// Transaction amount in cents
    public let amount: Int
    
    /// Bank code of originator or recipient. This field might be empty if the transaction has no bank code, e.g. interest transactions.
    public let bank_code: String
    
    /// Bank name of originator or recipient. This field might be empty if the transaction has no bank code, e.g. interest transactions.
    public let bank_name: String
    
    /// This flag indicates whether the transaction is booked or pending
    public let booked: Bool
    
    /// Booking date
    public let booking_date: String

    /// Booking text. This field might be empty if the transaction has no booking text.
    public let booking_text: String
    
    /// Internal creation timestamp on the figo Connect server
    public let creation_timestamp: String
    
    /// Three-character currency code
    public let currency: String
    
    /// Internal modification timestamp on the figo Connect server
    public let modification_timestamp: String
    
    /// Name of originator or recipient
    public let name: String
    
    /// Purpose text. This field might be empty if the transaction has no purpose.
    public let purpose: String
    
    /// Internal figo Connect transaction ID
    public let transaction_id: String
    
    /// Transaction type
    public let type: PaymentType
    
    /// Value date
    public let value_date: String
    
    /// This flag indicates whether the transaction has already been marked as visited by the user
    public let visited: Bool
    
    /// (optional) Provides more info about the transaction if available, depends on the account type
    public let additional_info: [String: AnyObject]?
    
    
    init(unboxer: Unboxer) {
        account_id = unboxer.unbox("account_id")
        account_number = unboxer.unbox("account_number")
        amount = unboxer.unbox("amount")
        bank_code = unboxer.unbox("bank_code")
        bank_name = unboxer.unbox("bank_name")
        booked = unboxer.unbox("booked")
        booking_date = unboxer.unbox("booking_date")
        booking_text = unboxer.unbox("booking_text")
        creation_timestamp = unboxer.unbox("creation_timestamp")
        currency = unboxer.unbox("currency")
        modification_timestamp = unboxer.unbox("modification_timestamp")
        name = unboxer.unbox("name")
        purpose = unboxer.unbox("purpose")
        transaction_id = unboxer.unbox("transaction_id")
        type = unboxer.unbox("type")
        value_date = unboxer.unbox("value_date")
        visited = unboxer.unbox("visited")
        additional_info = unboxer.unbox("additional_info")
    }
    
}
