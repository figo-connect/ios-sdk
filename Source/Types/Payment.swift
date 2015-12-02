//
//  Payment.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


internal struct PaymentListEnvelope: Unboxable {
    let payments: [Payment]
    
    init(unboxer: Unboxer) {
        payments = unboxer.unbox("payments")
    }
}

/**
 
- Note: Amounts in cents: NO (server problem)
 
*/
public struct Payment: Unboxable {
    
    /// Internal figo Connect payment ID
    public let paymentID: String
    
    /// Internal figo Connect account ID
    public let accountID: String
    
    /// Payment type
    public let type: PaymentType
    
    /// Name of creditor or debtor
    public var name: String
    
    /// Account number of creditor or debtor
    public var accountNumber: String
    
    /// Bank code of creditor or debtor
    public var bankCode: String
    
    /// Bank name of creditor or debtor
    public let bankName: String
    
    /// Icon of creditor or debtor bank
    public let bankIcon: String
    
    /// Dictionary mapping from resolution to URL for additional resolutions of the banks icon. Currently supports the following sizes:
    public let bankAdditionalIcons: [String: String]
    
    /// Order amount
    public var amount: Float
    
    /// String representation of the amount
    public var amountFormatted: String {
        currencyFormatter.currencyCode = self.currency
        return currencyFormatter.stringFromNumber(NSNumber(float: Float(amount)))!
    }
    
    private var currencyFormatter: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "de_DE")
        return formatter
    }
    
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
    public let submissionDate: FigoDate?
    
    /// Internal creation timestamp on the figo Connect server
    public let creationDate: FigoDate
    
    /// Internal modification timestamp on the figo Connect server
    public let modificationDate: FigoDate
    
    /// **optional** Recipient of the payment notification, should be an email address
    /// - Note: Only used when modifying an existing payment
    public var notificationRecipient: String?
    
    
    init(unboxer: Unboxer) {
        paymentID           = unboxer.unbox("payment_id")
        accountID           = unboxer.unbox("account_id")
        type                = unboxer.unbox("type")
        name                = unboxer.unbox("name")
        accountNumber       = unboxer.unbox("account_number")
        bankCode            = unboxer.unbox("bank_code")
        bankName            = unboxer.unbox("bank_name")
        bankIcon            = unboxer.unbox("bank_icon")
        bankAdditionalIcons = unboxer.unbox("bank_additional_icons")
        amount              = unboxer.unbox("amount")
        currency            = unboxer.unbox("currency")
        purpose             = unboxer.unbox("purpose")
        textKey             = unboxer.unbox("text_key")
        textKeyExtension    = unboxer.unbox("text_key_extension")
        container           = unboxer.unbox("container")
        submissionDate      = unboxer.unbox("submission_timestamp")
        creationDate        = unboxer.unbox("creation_timestamp")
        modificationDate    = unboxer.unbox("modification_timestamp")
    }
    
    
    // Used when modifying a payment
    var JSONObject: [String: AnyObject] {
        var dict = Dictionary<String, AnyObject>()
        dict["name"] = name
        dict["account_number"] = accountNumber
        dict["bank_code"] = bankCode
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

