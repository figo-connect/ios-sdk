//
//  RetrieveSecuritiesParameters.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//


/**

Defines how the parameter since will be interpreted.

*/
public enum SecuritySinceType: String, UnboxableEnum {
    
    /// The value of the parameter since will be compared to the time of the latest trade of the security
    case Traded = "traded"
    
    /// The value of the parameter since will be compared to the creation time of the security on the figo Connect server (default)
    case Created = "created"
    
    /// The value of the parameter since will be compared to the last modification time of the security on the figo Connect server.
    case Modified = "modified"
}


/**
 
 Parameters for RETRIEVE SECURITIES endpoints
 
 - Note: The default number for the limit parameter is 1000
 
 - Parameter accounts: **optional** If retrieving the securities for all accounts, filter the securities to be only from these accounts
 
 - Parameter since: **optional** ISO date filtering the returned securities by their creation or last modification date (depending on sync_type) being the same or a later date
 
 - Parameter sinceType: **optional** This parameter defines how the parameter since will be interpreted.
 
     *traded*
     
     The value of the parameter since will be compared to the time of the latest trade of the security
     
     *created*
     
     The value of the parameter since will be compared to the creation time of the security on the figo Connect server (default)
     
     *modified*
 
     The value of the parameter since will be compared to the last modification time of the security on the figo Connect server.
 
 - Parameter count: **optional** Limit the number of returned transactions. In combination with the offset parameter this can be used to paginate the result list. (default: 1000)
 
 - Parameter offset: **optional** Offset into the implicit list of transactions used as starting point for the returned transactions. In combination with the count parameter this can be used to paginate the result list.
 
 */
public struct RetrieveSecuritiesParameters: JSONObjectConvertible {
    
    public init(accounts: [String]? = nil, since: String? = nil, sinceType: TransactionSinceType? = nil, count: Int? = nil) {
        self.accounts = accounts
        self.since = since
        self.sinceType = sinceType
        self.count = count
    }
    
    /// **optional** If retrieving the securities for all accounts, filter the transactions to be only from these accounts
    public var accounts: [String]?
    
    /// ISO date filtering the returned securities by their creation or last modification date (depending on sync_type) being the same or a later date
    public var since: String?
    
    /**
     **optional** This parameter defines how the parameter since will be interpreted.
     
     *traded*
     
     The value of the parameter since will be compared to the time of the latest trade of the security
     
     *created (default)*
     
     The value of the parameter since will be compared to the creation time of the security on the figo Connect server (default)
     
     *modified*
     
     The value of the parameter since will be compared to the last modification time of the security on the figo Connect server.
     */
    public var sinceType: TransactionSinceType?
    
    /// **optional** Limit the number of returned securities. In combination with the offset parameter this can be used to paginate the result list. (default: 1000)
    public var count: Int?
    
    /// **optional** Offset into the implicit list of securities used as starting point for the returned securities. In combination with the count parameter this can be used to paginate the result list.
    public var offset: Int?
    
    
    var JSONObject: [String: AnyObject] {
        var dict = Dictionary<String, AnyObject>()
        dict["accounts"] = accounts as AnyObject?
        dict["since"] = since as AnyObject?
        dict["since_type"] = sinceType?.rawValue as AnyObject?
        dict["count"] = count as AnyObject?
        dict["offset"] = offset as AnyObject?
        dict["cents"] = true as AnyObject?
        return dict
    }
}



