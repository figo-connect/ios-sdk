//
//  Account.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


/**
 Bank accounts are the central domain object of this API and the main anchor point for many of the other resources. This API does not only consider classical bank accounts as account, but also alternative banking services, e.g. credit cards or Paypal. The API does not distinguish between these two in most points.
*/
public struct Account {
    
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
    public let status: SyncStatus?
    
    /// Account balance; This response parameter will be omitted if the balance is not yet known
    public let balance: Balance?
}

extension Account: ResponseObjectSerializable {
    
    public init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        account_id              = try mapper.valueForKeyName("account_id")
        account_number          = try mapper.valueForKeyName("account_number")
        additional_icons        = try mapper.valueForKeyName("additional_icons")
        auto_sync               = try mapper.valueForKeyName("auto_sync")
        balance                 = try Balance(optionalRepresentation: mapper.optionalForKeyName("balance"))
        bank_code               = try mapper.valueForKeyName("bank_code")
        bank_id                 = try mapper.valueForKeyName("bank_id")
        bank_name               = try mapper.valueForKeyName("bank_name")
        bic                     = try mapper.valueForKeyName("bic")
        currency                = try mapper.valueForKeyName("currency")
        iban                    = try mapper.valueForKeyName("iban")
        icon                    = try mapper.valueForKeyName("icon")
        in_total_balance        = try mapper.valueForKeyName("in_total_balance")
        name                    = try mapper.valueForKeyName("name")
        owner                   = try mapper.valueForKeyName("owner")
        preferred_tan_scheme    = try mapper.optionalForKeyName("preferred_tan_scheme")
        save_pin                = try mapper.valueForKeyName("save_pin")
        status                  = try SyncStatus(representation: mapper.valueForKeyName("status"))
        supported_payments      = try PaymentParameters.collection(mapper.valueForKeyName("supported_payments"))
        supported_tan_schemes   = try TanScheme.collection(mapper.valueForKeyName("supported_tan_schemes"))
        type                    = try mapper.valueForKeyName("type")
    }
}

extension Account: ResponseCollectionSerializable {
    
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

/**
 Contains the parameters for setting up a new bank account
 */
public struct CreateAccountParameters {
    
    /// Bank code (optional)
    public let bank_code: String?
    
    /// IBAN (optional)
    public let iban: String?
    
    /// Two-letter country code (valid values: de)
    let country: String = "de"
    
    /// List of login credential strings. They must be in the same order as in the credentials list from the login settings
    public let credentials: [String]
    
    /// This flag indicates whether the user has chosen to save the PIN on the figo Connect server. It is mandatory if the authentication type in the login settings of the bank code is pin and will be ignored otherwise.
    public let save_pin: Bool
    
    /// This flag indicates whether the initial sync of the transactions and balances of the newly created accounts should be omitted. If this is the case certain listed accounts might actually be invalid (e.g. old creditcards) and will be automatically removed at the first sync. (optional)
    public let disable_first_sync: Bool?
    
    /// List of additional information to be fetched from the bank. Possible values are: standingOrders (optional)
    public let sync_tasks: [String]?
    
    public var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict["bank_code"] = bank_code
            dict["iban"] = iban
            dict["country"] = country
            dict["credentials"] = credentials
            dict["save_pin"] = save_pin
            dict["disable_first_sync"] = disable_first_sync
            dict["sync_tasks"] = sync_tasks
            return dict
        }
    }
}

