//
//  Payment.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct Payment: Unboxable {
    
    /// Internal figo Connect payment ID
    public let payment_id: String
    
    /// Internal figo Connect account ID
    public let account_id: String
    
    /// Payment type
    public let type: PaymentType
    
    /// Name of creditor or debtor
    public let name: String
    
    /// Account number of creditor or debtor
    public let account_number: String
    
    /// Bank code of creditor or debtor
    public let bank_code: String
    
    /// Bank name of creditor or debtor
    public let bank_name: String
    
    /// Icon of creditor or debtor bank
    public let bank_icon: String
    
    /// Dictionary mapping from resolution to URL for additional resolutions of the banks icon. Currently supports the following sizes:
    public let bank_additional_icons: [String: String]
    
    /// Order amount
    public let amount: Int
    
    /// Three-character currency code
    public let currency: String
    
    /// Purpose text. This field might be empty if the transaction has no purpose.
    public let purpose: String
    
    /// DTA text key
    public let textKey: Int
    
    /// DTA text key extension
    public let textKeyExtension: Int
    
    /// If this payment object is a container for multiple payments, then this field is set and contains a list of payment objects
    public let container: [Payment]?
    
    /// Timestamp of submission to the bank server.
    public let submission_timestamp: String?
    
    /// Internal creation timestamp on the figo Connect server
    public let creation_timestamp: String
    
    /// Internal modification timestamp on the figo Connect server
    public let modification_timestamp: String
    
    
    init(unboxer: Unboxer) {
        payment_id = unboxer.unbox("payment_id")
        account_id = unboxer.unbox("account_id")
        type = unboxer.unbox("type")
        name = unboxer.unbox("name")
        account_number = unboxer.unbox("account_number")
        bank_code = unboxer.unbox("bank_code")
        bank_name = unboxer.unbox("bank_name")
        bank_icon = unboxer.unbox("bank_icon")
        bank_additional_icons = unboxer.unbox("bank_additional_icons")
        amount = unboxer.unbox("amount")
        currency = unboxer.unbox("currency")
        purpose = unboxer.unbox("purpose")
        textKey = unboxer.unbox("text_key")
        textKeyExtension = unboxer.unbox("text_key_extension")
        container = unboxer.unbox("container")
        submission_timestamp = unboxer.unbox("submission_timestamp")
        creation_timestamp = unboxer.unbox("creation_timestamp")
        modification_timestamp = unboxer.unbox("modification_timestamp")
    }
    
}

