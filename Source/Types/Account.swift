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
    public let account_id: String
    
    /// Internal figo Connect bank ID
    public let bank_id: String
    
    /// Account name
    public let name: String
    
    /// Account owner
    public let owner: String
    
    public /// This flag indicates whether the account will be automatically synchronized
    let auto_sync: Bool
    
    /// Account number
    public let account_number: String
    
    /// Bank code
    public let bank_code: String
    
    /// Bank name
    public let bank_name: String
    
    /// Three-character currency code
    public let currency: String
    
    /// IBAN
    public let iban: String
    
    /// BIC
    public let bic: String
    
    /**
     Account type
     
     Independent of the integration of the bank account into figo, the following kinds of bank accounts are defined: Giro account, Savings account, Credit card, Loan account, PayPal, Cash book, Depot and Unknown.
     */
    public let type: String

    /// Account icon URL
    public let icon: String
    
    /**
     Dictionary mapping from resolution to URL for additional resolutions of the banks icon. Currently supports the following sizes:
     
     48x48 60x60 72x72 84x84 96x96 120x120 144x144 192x192 256x256
     */
    public let additional_icons: [String: String]
    
    /// List of payment types with payment parameters
    public let supported_payments: [PaymentParameters]

    // List of TAN schemes
    public let supported_tan_schemes: [TanScheme]
    
    /// ID of the TAN scheme preferred by the user
    public let preferred_tan_scheme: String?

    // This flag indicates whether the balance of this account is added to the total balance of accounts
    public let in_total_balance: Bool

    /// This flag indicates whether the user has chosen to save the PIN on the figo Connect server
    public let save_pin: Bool

    /// Synchronization status
    public let status: SyncStatus
    
    /// Account balance; This response parameter will be omitted if the balance is not yet known
    /// TODO: Verify, make optional
    public let balance: Balance

    
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

