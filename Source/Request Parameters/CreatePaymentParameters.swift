//
//  CreatePaymentParameters.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


/**

Parameters for creating a payment

- Parameters:
    - accountID: **required** Internal figo connect ID of the account
    - type: **required** Payment type (valid values: Transfer, Direct debit, SEPA transfer, SEPA direct debit, SEPA standing order, Modify SEPA standing order)
    - name: **required** Name of creditor or debtor
    - amount: **required** Order amount
    - purpose: **required** Purpose text
    - accountNumber: **optional** Account number of creditor or debtor
    - bankCode: **optional** Bank code of creditor or debtor
    - iban: **optional** IBAN of creditor or debtor. Will overwrite bank_code and account_number if both are set
    - currency: **optional** Three-character currency code (default: EUR)
    - textKey: **optional** DTA text key (default: 51)
    - textKeyExtension: **optional** DTA text key extension
    - notificationRecipient: **optional** Recipient of the payment notification, should be an email address

- Note: Either bankCode & accountNumber or iban has to be set

*/
public struct CreatePaymentParameters: JSONObjectConvertible {
    
    /// **required** Internal figo connect ID of the account
    public let accountID: String
    
    /// **required** Payment type (valid values: Transfer, Direct debit, SEPA transfer, SEPA direct debit, SEPA standing order, Modify SEPA standing order)
    public let type: PaymentType
    
    /// **required** Name of creditor or debtor
    public let name: String
    
    /// **required** Order amount
    public let amount: Float
    
    /// **required** Purpose text
    public let purpose: String
    
    /// **optional** Account number of creditor or debtor
    public var accountNumber: String?
    
    /// **optional Bank code of creditor or debtor
    public var bankCode: String?

    /// **optional IBAN of creditor or debtor. Will overwrite bankCode and accountNumber if both are set
    public var iban: String?
    
    /// **optional Three-character currency code (default: EUR)
    public var currency: String?

    /// **optional** DTA text key (default: 51)
    public var textKey: Int?

    /// **optional** DTA text key extension
    public var textKeyExtension: Int?

    /// **optional** Recipient of the payment notification, should be an email address
    public var notificationRecipient: String?
    
    
    public init(accountID: String, type: PaymentType, name: String, amount: Float, purpose: String, accountNumber: String? = nil, bankCode: String? = nil, iban: String? = nil, currency: String? = nil, textKey: Int? = nil, textKeyExtension: Int? = nil, notificationRecipient: String? = nil) {
        self.accountID = accountID
        self.type = type
        self.name = name
        self.amount = amount
        self.purpose = purpose
        self.accountNumber = accountNumber
        self.bankCode = bankCode
        self.iban = iban
        self.currency = currency
        self.textKey = textKey
        self.textKeyExtension = textKeyExtension
        self.notificationRecipient = notificationRecipient
    }
    
    var JSONObject: [String: AnyObject] {
        var dict = Dictionary<String, AnyObject>()
        dict["account_id"] = accountID as AnyObject?
        dict["type"] = type.rawValue as AnyObject?
        dict["name"] = name as AnyObject?
        dict["amount"] = amount as AnyObject?
        dict["purpose"] = purpose as AnyObject?
        dict["account_number"] = accountNumber as AnyObject?
        dict["bank_code"] = bankCode as AnyObject?
        dict["iban"] = iban as AnyObject?
        dict["currency"] = currency as AnyObject?
        dict["text_key"] = textKey as AnyObject?
        dict["text_key_extension"] = textKeyExtension as AnyObject?
        dict["notification_recipient"] = notificationRecipient as AnyObject?
//        dict["cents"] = true
        return dict
    }
    
}

