//
//  Account.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


internal struct AccountListEnvelope: Unboxable {
    let accounts: [Account]
    
    init(unboxer: Unboxer) {
        accounts = unboxer.unbox("accounts")
    }
}


/**
 Bank accounts are the central domain object of this API and the main anchor point for many of the other resources. This API does not only consider classical bank accounts as account, but also alternative banking services, e.g. credit cards or Paypal. The API does not distinguish between these two in most points.
*/
public struct Account: Unboxable {
    
    /// Internal figo Connect account ID
    public let accountID: String
    
    /// Internal figo Connect bank ID
    public let bankID: String
    
    /// Account name
    public let name: String
    
    /// Account owner
    public let owner: String
    
    /// This flag indicates whether the account will be automatically synchronized
    public let autoSync: Bool
    
    /// Account number
    public let accountNumber: String
    
    /// Bank code
    public let bankCode: String
    
    /// Bank name
    public let bankName: String
    
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
    public let type: AccountType

    /// Account icon URL
    public let icon: String
    
    /**
     Dictionary mapping from resolution to URL for additional resolutions of the banks icon. Currently supports the following sizes:
     48x48 60x60 72x72 84x84 96x96 120x120 144x144 192x192 256x256
     */
    public let additionalIcons: [String: String]
    
    /// List of payment types with payment parameters
    public let supportedPayments: [(PaymentType, PaymentParameters)]

    // List of TAN schemes
    public let supportedTANSchemes: [TANScheme]
    
    /// ID of the TAN scheme preferred by the user
    public let preferredTANScheme: String?

    // This flag indicates whether the balance of this account is added to the total balance of accounts
    public let inTotalBalance: Bool

    /// This flag indicates whether the user has chosen to save the PIN on the figo Connect server
    public let savePin: Bool

    /// Synchronization status
    public let status: SyncStatus?
    
    /// Account balance; This response parameter will be omitted if the balance is not yet known
    public let balance: Balance?
    
    /// String representation of the account balance
    public var balanceFormatted: String? {
        if let cents = balance?.balance {
            currencyFormatter.currencyCode = self.currency
            return currencyFormatter.stringFromNumber(NSNumber(double: Double(cents)/100.0))
        }
        return nil
    }
    
    private var currencyFormatter: NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "de_DE")
        return formatter
    }
    
    public init(unboxer: Unboxer) {
        accountID           = unboxer.unbox("account_id")
        accountNumber       = unboxer.unbox("account_number")
        additionalIcons     = unboxer.unbox("additional_icons")
        autoSync            = unboxer.unbox("auto_sync")
        balance             = unboxer.unbox("balance")
        bankCode            = unboxer.unbox("bank_code")
        bankID              = unboxer.unbox("bank_id")
        bankName            = unboxer.unbox("bank_name")
        bic                 = unboxer.unbox("bic")
        currency            = unboxer.unbox("currency")
        iban                = unboxer.unbox("iban")
        icon                = unboxer.unbox("icon")
        inTotalBalance      = unboxer.unbox("in_total_balance")
        name                = unboxer.unbox("name")
        owner               = unboxer.unbox("owner")
        preferredTANScheme  = unboxer.unbox("preferred_tan_scheme")
        savePin             = unboxer.unbox("save_pin")
        status              = unboxer.unbox("status")
        supportedTANSchemes = unboxer.unbox("supported_tan_schemes")
        type                = unboxer.unbox("type")
        
        // Special treatment for supported payments because the payment type values are stored in keys instead of values
        supportedPayments      = (unboxer.unbox("supported_payments") as [String: AnyObject]).keys.map() { paymentType in
            return (PaymentType(rawValue: paymentType) ?? PaymentType.Unknown, unboxer.unbox("supported_payments.\(paymentType)"))
        }
    }
}


