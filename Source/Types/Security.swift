//
//  Security.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//



public struct SecurityListEnvelope: Unboxable {
    
    public let securities: [Security]
    public let deleted: [Security]
    public let status: SyncStatus
    
    init(unboxer: Unboxer) {
        securities = unboxer.unbox("securities")
        deleted = unboxer.unbox("deleted")
        status = unboxer.unbox("status")
    }
}


/**
 
Each depot account has a list of securities associated with it. In general the information provided for each security should be roughly similar to the contents of the printed or online depot listings available from the respective bank. Please note that not all banks provide the same level of detail.
 
- Note: All amounts are in cents
 
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
    
    /// Three-character currency code
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
    
    /// Purchase price
    public let purchasePrice: Int
    
    /// Currency of purchase price
    public let purchasePriceCurrency: String
    
    /// This flag indicates whether the security has already been marked as visited by the user
    public let visited: Bool
    
    /// Trading timestamp
    public let tradeDate: FigoDate
    
    /// Internal creation timestamp on the figo Connect server
    public let creationDate: FigoDate
    
    /// Internal modification timestamp on the figo Connect server
    public let modificationDate: FigoDate
    

    init(unboxer: Unboxer) {
        securityID = unboxer.unbox("security_id")
        accountID = unboxer.unbox("account_id")
        name = unboxer.unbox("name")
        isin = unboxer.unbox("isin")
        wkn = unboxer.unbox("wkn")
        currency = unboxer.unbox("currency")
        quantity = unboxer.unbox("quantity")
        amount = unboxer.unbox("amount")
        amountOriginalCurrency = unboxer.unbox("amount_original_currency")
        exchangeRate = unboxer.unbox("exchange_rate")
        price = unboxer.unbox("price")
        priceCurrency = unboxer.unbox("price_currency")
        purchasePrice = unboxer.unbox("purchase_price")
        purchasePriceCurrency = unboxer.unbox("purchase_price_currency")
        visited = unboxer.unbox("visited")
        tradeDate = unboxer.unbox("trade_timestamp")
        creationDate = unboxer.unbox("creation_timestamp")
        modificationDate = unboxer.unbox("modification_timestamp")
        market = unboxer.unbox("market")
    }
    
}

