//
//  Payment.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Unbox


internal struct PaymentListEnvelope: Unboxable {
    let payments: [Payment]
    
    init(unboxer: Unboxer) throws {
        payments = try unboxer.unbox(key: "payments")
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
        return currencyFormatter.string(from: NSNumber(value: Float(amount) as Float))!
    }
    
    fileprivate var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "de_DE")
        return formatter
    }
    
    /// Three-character currency code
    public var currency: String
    
    /// Purpose text. This field might be empty if the transaction has no purpose.
    public var purpose: String?
    
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
    
    
    public init(unboxer: Unboxer) throws {
        self.paymentID           = try unboxer.unbox(key: "payment_id")
        self.accountID           = try unboxer.unbox(key: "account_id")
        self.type                = try unboxer.unbox(key: "type")
        self.name                = try unboxer.unbox(key: "name")
        self.accountNumber       = try unboxer.unbox(key: "account_number")
        self.bankCode            = try unboxer.unbox(key: "bank_code")
        self.bankName            = try unboxer.unbox(key: "bank_name")
        self.bankIcon            = try unboxer.unbox(key: "bank_icon")
        self.bankAdditionalIcons = try unboxer.unbox(key: "bank_additional_icons")
        self.amount              = try unboxer.unbox(key: "amount")
        self.currency            = try unboxer.unbox(key: "currency")
        self.purpose             = unboxer.unbox(key: "purpose")
        self.textKey             = try unboxer.unbox(key: "text_key")
        self.textKeyExtension    = try unboxer.unbox(key: "text_key_extension")
        self.container           = unboxer.unbox(key: "container")
        self.submissionDate      = unboxer.unbox(key: "submission_timestamp")
        self.creationDate        = try unboxer.unbox(key: "creation_timestamp")
        self.modificationDate    = try unboxer.unbox(key: "modification_timestamp")
    }
    
    
    // Used when modifying a payment
    var JSONObject: [String: AnyObject] {
        var dict = Dictionary<String, AnyObject>()
        dict["name"] = name as AnyObject?
        dict["account_number"] = accountNumber as AnyObject?
        dict["bank_code"] = bankCode as AnyObject?
        dict["amount"] = amount as AnyObject?
        dict["currency"] = currency as AnyObject?
        dict["purpose"] = purpose as AnyObject?
        dict["text_key"] = textKey as AnyObject?
        dict["text_key_extension"] = textKeyExtension as AnyObject?
        dict["notification_recipient"] = notificationRecipient as AnyObject?
//        dict["cents"] = true
        return dict
    }
    
}

