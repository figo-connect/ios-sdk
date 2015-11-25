//
//  Account.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


/**
 Bank accounts are the central domain object of this API and the main anchor point for many of the other resources. This API does not only consider classical bank accounts as account, but also alternative banking services, e.g. credit cards or Paypal. The API does not distinguish between these two in most points.

*/
public struct Account: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    /// Internal figo Connect account ID
    let account_id: String
    
    /// Internal figo Connect bank ID
    let bank_id: String
    
    /// Account name
    let name: String
    
    /// Account owner
    let owner: String
    
    /// This flag indicates whether the account will be automatically synchronized
    let auto_sync: Bool
    
    /// Account number
    let account_number: String
    
    /// Bank code
    let bank_code: String
    
    /// Bank name
    let bank_name: String
    
    /// Three-character currency code
    let currency: String
    
    /// IBAN
    let iban: String
    
    /// BIC
    let bic: String
    
    /**
     Account type
     
     Independent of the integration of the bank account into figo, the following kinds of bank accounts are defined: Giro account, Savings account, Credit card, Loan account, PayPal, Cash book, Depot and Unknown.
     */
    let type: String

    /// Account icon URL
    let icon: String
    
    /**
     Dictionary mapping from resolution to URL for additional resolutions of the banks icon. Currently supports the following sizes:
     
     48x48 60x60 72x72 84x84 96x96 120x120 144x144 192x192 256x256
     */
    let additional_icons: [String: String]
    
    /// List of payment types with payment parameters
    let supported_payments: [PaymentParameters]

    // List of TAN schemes
    let supported_tan_schemes: [TanScheme]
    
    /// ID of the TAN scheme preferred by the user
    let preferred_tan_scheme: String?

    // This flag indicates whether the balance of this account is added to the total balance of accounts
    let in_total_balance: Bool

    /// This flag indicates whether the user has chosen to save the PIN on the figo Connect server
    let save_pin: Bool

    /// Synchronization status
    let status: SyncStatus
    
    /// Account balance; This response parameter will be omitted if the balance is not yet known
    /// TODO: Verify, make optional
    let balance: Balance


    private enum Key: String, PropertyKey {
        case account_id
        case account_number
        case additional_icons
        case auto_sync
        case balance
        case bank_code
        case bank_id
        case bank_name
        case bic
        case currency
        case iban
        case icon
        case in_total_balance
        case name
        case owner
        case preferred_tan_scheme
        case save_pin
        case status
        case supported_payments
        case supported_tan_schemes
        case type
    }
    
    public init(representation: AnyObject) throws {
        let mapper = try PropertyMapper(representation, typeName: "\(self.dynamicType)")
        
        account_id              = try mapper.valueForKey(Key.account_id)
        account_number          = try mapper.valueForKey(Key.account_number)
        additional_icons        = try mapper.valueForKey(Key.additional_icons)
        auto_sync               = try mapper.valueForKey(Key.auto_sync)
        balance                 = try Balance(representation: mapper.valueForKey(Key.balance))
        bank_code               = try mapper.valueForKey(Key.bank_code)
        bank_id                 = try mapper.valueForKey(Key.bank_id)
        bank_name               = try mapper.valueForKey(Key.bank_name)
        bic                     = try mapper.valueForKey(Key.bic)
        currency                = try mapper.valueForKey(Key.currency)
        iban                    = try mapper.valueForKey(Key.iban)
        icon                    = try mapper.valueForKey(Key.icon)
        in_total_balance        = try mapper.valueForKey(Key.in_total_balance)
        name                    = try mapper.valueForKey(Key.name)
        owner                   = try mapper.valueForKey(Key.owner)
        preferred_tan_scheme    = try mapper.optionalValueForKey(Key.preferred_tan_scheme)
        save_pin                = try mapper.valueForKey(Key.save_pin)
        status                  = try SyncStatus(representation: mapper.valueForKey(Key.status))
        supported_payments      = try PaymentParameters.collection(mapper.valueForKey(Key.supported_payments))
        supported_tan_schemes   = try TanScheme.collection(mapper.valueForKey(Key.supported_tan_schemes))
        type                    = try mapper.valueForKey(Key.type)
    }
    
    var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict[Key.account_id.rawValue] = account_id
            dict[Key.account_number.rawValue] = account_number
            return dict
        }
    }
    
    public static func collection(representation: AnyObject) throws -> [Account] {
        var accounts: [Account] = []
        if let representation = representation as? [String: AnyObject] {
            if let representation = representation["accounts"] as? [[String: AnyObject]] {
                for userRepresentation in representation {
                    let account = try Account(representation: userRepresentation)
                    accounts.append(account)
                }
            }
        }
        return accounts
    }
}

extension Account: CustomStringConvertible {
    public var description: String {
        get {
            if let data = try? NSJSONSerialization.dataWithJSONObject(JSONObject, options: NSJSONWritingOptions.PrettyPrinted) {
                if let string = String(data: data, encoding: NSUTF8StringEncoding) {
                    return string
                }
            }
            return ""
        }
    }
}
