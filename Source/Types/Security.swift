//
//  Security.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct SecurityListEnvelope: Unboxable {
    
    public let securities: [Security]
    public let deleted: [Security]
    public let status: SyncStatus
    
    init(unboxer: Unboxer) throws {
        securities = try unboxer.unbox(key: "securities")
        deleted = try unboxer.unbox(key: "deleted")
        status = try unboxer.unbox(key: "status")
    }
}


/**
 
Each depot account has a list of securities associated with it. In general the information provided for each security should be roughly similar to the contents of the printed or online depot listings available from the respective bank. Please note that not all banks provide the same level of detail.
 
- Note: Amounts in cents: YES
 
 */
public struct Security: Unboxable {
    
    /// Internal figo Connect security ID
    public let securityID: String
    
    /// Internal figo Connect account ID
    public let accountID: String
    
    /// Name of the security
    public let name: String
    
    /// International Securities Identification Number
    public let isin: String
    
    /// Wertpapierkennnummer (if available)
    public let wkn: String
    
    public let market: String
    
    /// Three-character currency code when measured in currency (and not pieces)
    public let currency: String
    
    /// Number of pieces or value
    public let quantity: Int
    
    /// Monetary value in account currency
    public let amount: Int
    
    /// Monetary value in trading currency
    public let amountOriginalCurrency: Int
    
    /// Exchange rate between trading and account currency
    public let exchangeRate: Float
    
    /// Current price
    public let price: Int
    
    /// Currency of current price
    public let priceCurrency: String
    
    /// String representation of current price
    public var priceFormatted: String {
        currencyFormatter.currencyCode = currency
        return currencyFormatter.string(from: NSNumber(value: Float(price)/100.0 as Float))!
    }
    
    /// Purchase price
    public let purchasePrice: Int
    
    /// Currency of purchase price
    public let purchasePriceCurrency: String
    
    /// String representation of purchase price
    public var purchasePriceFormatted: String {
        currencyFormatter.currencyCode = currency
        return currencyFormatter.string(from: NSNumber(value: Float(purchasePrice)/100.0 as Float))!
    }
    
    /// This flag indicates whether the security has already been marked as visited by the user
    public let visited: Bool
    
    /// Trading timestamp
    public let tradeDate: FigoDate
    
    /// Internal creation timestamp on the figo Connect server
    public let creationDate: FigoDate
    
    /// Internal modification timestamp on the figo Connect server
    public let modificationDate: FigoDate
    
    
    fileprivate var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "de_DE")
        return formatter
    }
    

    init(unboxer: Unboxer) throws {
        securityID              = try unboxer.unbox(key: "security_id")
        accountID               = try unboxer.unbox(key: "account_id")
        name                    = try unboxer.unbox(key: "name")
        isin                    = try unboxer.unbox(key: "isin")
        wkn                     = try unboxer.unbox(key: "wkn")
        currency                = try unboxer.unbox(key: "currency")
        quantity                = try unboxer.unbox(key: "quantity")
        amount                  = try unboxer.unbox(key: "amount")
        amountOriginalCurrency  = try unboxer.unbox(key: "amount_original_currency")
        exchangeRate            = try unboxer.unbox(key: "exchange_rate")
        price                   = try unboxer.unbox(key: "price")
        priceCurrency           = try unboxer.unbox(key: "price_currency")
        purchasePrice           = try unboxer.unbox(key: "purchase_price")
        purchasePriceCurrency   = try unboxer.unbox(key: "purchase_price_currency")
        visited                 = try unboxer.unbox(key: "visited")
        tradeDate               = try unboxer.unbox(key: "trade_timestamp")
        creationDate            = try unboxer.unbox(key: "creation_timestamp")
        modificationDate        = try unboxer.unbox(key: "modification_timestamp")
        market                  = try unboxer.unbox(key: "market")
    }
    
}

