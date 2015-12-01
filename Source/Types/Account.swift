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
public struct Account: Unboxable {
    
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
    public let supported_payments: [(PaymentType, PaymentParameters)]

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
    
    
    init(unboxer: Unboxer) {
        account_id              = unboxer.unbox("account_id")
        account_number          = unboxer.unbox("account_number")
        additional_icons        = unboxer.unbox("additional_icons")
        auto_sync               = unboxer.unbox("auto_sync")
        balance                 = unboxer.unbox("balance")
        bank_code               = unboxer.unbox("bank_code")
        bank_id                 = unboxer.unbox("bank_id")
        bank_name               = unboxer.unbox("bank_name")
        bic                     = unboxer.unbox("bic")
        currency                = unboxer.unbox("currency")
        iban                    = unboxer.unbox("iban")
        icon                    = unboxer.unbox("icon")
        in_total_balance        = unboxer.unbox("in_total_balance")
        name                    = unboxer.unbox("name")
        owner                   = unboxer.unbox("owner")
        preferred_tan_scheme    = unboxer.unbox("preferred_tan_scheme")
        save_pin                = unboxer.unbox("save_pin")
        status                  = unboxer.unbox("status")
        supported_tan_schemes   = unboxer.unbox("supported_tan_schemes")
        type                    = unboxer.unbox("type")
        supported_payments      = (unboxer.unbox("supported_payments") as [String: AnyObject]).keys.map() { paymentType in
            return (PaymentType(rawValue: paymentType) ?? PaymentType.Unknown, unboxer.unbox("supported_payments.\(paymentType)"))
        }
    }
}


