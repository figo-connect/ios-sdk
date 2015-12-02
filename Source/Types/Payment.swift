//
//  Payment.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


internal struct PaymentListEnvelope: Unboxable {
    let payments: [Payment]
    
    init(unboxer: Unboxer) {
        payments = unboxer.unbox("payments")
    }
}


public struct Payment: Unboxable {
    
    /// Internal figo Connect payment ID
    public let payment_id: String
    
    /// Internal figo Connect account ID
    public let account_id: String
    
    /// Payment type
    public let type: PaymentType
    
    /// Name of creditor or debtor
    public var name: String
    
    /// Account number of creditor or debtor
    public var account_number: String
    
    /// Bank code of creditor or debtor
    public var bank_code: String
    
    /// Bank name of creditor or debtor
    public let bank_name: String
    
    /// Icon of creditor or debtor bank
    public let bank_icon: String
    
    /// Dictionary mapping from resolution to URL for additional resolutions of the banks icon. Currently supports the following sizes:
    public let bank_additional_icons: [String: String]
    
    /// Order amount
    public var amount: Float
    
    /// Three-character currency code
    public var currency: String
    
    /// Purpose text. This field might be empty if the transaction has no purpose.
    public var purpose: String
    
    /// DTA text key
    public var textKey: Int
    
    /// DTA text key extension
    public var textKeyExtension: Int
    
    /// If this payment object is a container for multiple payments, then this field is set and contains a list of payment objects
    public let container: [Payment]?
    
    /// Timestamp of submission to the bank server.
    public let submission_timestamp: String?
    
    /// Internal creation timestamp on the figo Connect server
    public let creation_timestamp: String
    
    /// Internal modification timestamp on the figo Connect server
    public let modification_timestamp: String
    
    /// **optional** Recipient of the payment notification, should be an email address
    /// - Note: Only used when modifying an existing payment
    public var notificationRecipient: String?
    
    
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
    
    
    // Used when modifying a payment
    var JSONObject: [String: AnyObject] {
        var dict = Dictionary<String, AnyObject>()
        dict["name"] = name
        dict["account_number"] = account_number
        dict["bank_code"] = bank_code
        dict["amount"] = amount
        dict["currency"] = currency
        dict["purpose"] = purpose
        dict["text_key"] = textKey
        dict["text_key_extension"] = textKeyExtension
        dict["notification_recipient"] = notificationRecipient
//        dict["cents"] = true
        return dict
    }
    
}

