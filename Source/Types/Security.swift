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
    public let security_id: String
    
    /// Internal figo Connect account ID
    public let account_id: String
    
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
    public let amount_original_currency: Int
    
    /// Exchange rate between trading and account currency
    public let exchange_rate: Float
    
    /// Current price
    public let price: Int
    
    /// Currency of current price
    public let price_currency: String
    
    /// Purchase price
    public let purchase_price: Int
    
    /// Currency of purchase price
    public let purchase_price_currency: String
    
    /// This flag indicates whether the security has already been marked as visited by the user
    public let visited: Bool
    
    /// Trading timestamp
    public let trade_timestamp: String
    
    /// Internal creation timestamp on the figo Connect server
    public let creation_timestamp: String
    
    /// Internal modification timestamp on the figo Connect server
    public let modification_timestamp: String
    

    init(unboxer: Unboxer) {
        security_id = unboxer.unbox("security_id")
        account_id = unboxer.unbox("account_id")
        name = unboxer.unbox("name")
        isin = unboxer.unbox("isin")
        wkn = unboxer.unbox("wkn")
        currency = unboxer.unbox("currency")
        quantity = unboxer.unbox("quantity")
        amount = unboxer.unbox("amount")
        amount_original_currency = unboxer.unbox("amount_original_currency")
        exchange_rate = unboxer.unbox("exchange_rate")
        price = unboxer.unbox("price")
        price_currency = unboxer.unbox("price_currency")
        purchase_price = unboxer.unbox("purchase_price")
        purchase_price_currency = unboxer.unbox("purchase_price_currency")
        visited = unboxer.unbox("visited")
        trade_timestamp = unboxer.unbox("trade_timestamp")
        creation_timestamp = unboxer.unbox("creation_timestamp")
        modification_timestamp = unboxer.unbox("modification_timestamp")
        market = unboxer.unbox("market")
    }
    
}

