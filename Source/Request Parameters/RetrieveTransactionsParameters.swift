//
//  RetrieveTransactionsParameters.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


/**

Defines how the parameter since will be interpreted.

*/
public enum TransactionSinceType: String, UnboxableEnum {
    
    /// The value of the parameter since will be compared to the booking date of the transaction. (default)
    case Booked = "booked"
    
    /// The value of the parameter since will be compared to the creation time of the transaction on the figo Connect server
    case Created = "created"
    
    /// The value of the parameter since will be compared to the last modification time of the transaction on the figo Connect server. The response parameter transactions will contain not only newly created transactions but also modified transactions. The response parameter deleted will contain a list of removed transactions.
    case Modified = "modified"

}


/**
 
Parameters for RETRIEVE TRANSACTIONS endpoints
 
- Note: The default number for the limit parameter is 1000
 
 
- Parameter accounts: **optional** If retrieving the transactions for all accounts, filter the transactions to be only from these accounts
 
- Parameter since: **optional** This parameter can either be a transaction ID or an ISO date.
 
    *transaction ID*
     
    the transactions which are newer than the referenced transaction will be returned in the response. The exact meaning of newer depends on the value of since_type
     
    *ISO date*
     
    the transactions which were booked on or after this date will be returned in the response
     
- Parameter sinceType: **optional** This parameter defines how the parameter since will be interpreted.
     
    *booked (default)*
     
    the value of the parameter since will be compared to the booking date of the transaction.
     
    *created*
     
    the value of the parameter since will be compared to the creation time of the transaction on the figo Connect server
     
    *modified*
     
    the value of the parameter since will be compared to the last modification time of the transaction on the figo Connect server. The response parameter transactions will contain not only newly created transactions but also modified transactions. The response parameter deleted will contain a list of removed transactions.
 
- Parameter until: **optional** Return only transactions which were booked on or before this date. Please provide as ISO date
 
- Parameter filter: **optional** Filter expression to narrow down the returned transactions
 
- Parameter count: **optional** Limit the number of returned transactions. In combination with the offset parameter this can be used to paginate the result list. (default: 1000)
 
- Parameter offset: **optional** Offset into the implicit list of transactions used as starting point for the returned transactions. In combination with the count parameter this can be used to paginate the result list.
 
- Parameter includePending: **optional** This flag indicates whether pending transactions should be included in the response. Pending transactions are always included as a complete set, regardless of the since parameter. Before caching a copy of the pending transactions, all existing pending transactions for the same account must be removed from the local cache. (default: false)
 
- Parameter includeStatistics: **optional** This flag indicates whether statistics over the filtered transaction list should returned alongside the actual transactions. These statistics are always computed on the complete filtered transaction list, i.e. without count and offset. (default: false)
 
- Parameter type: **optional** A list of transactions types which the transactions are filtered by.
 
 */
public struct RetrieveTransactionsParameters: JSONObjectConvertible {
    
    /// **optional** If retrieving the transactions for all accounts, filter the transactions to be only from these accounts
    public var accounts: [String]?
    
    /**
     **optional** This parameter can either be a transaction ID or an ISO date.
     
     *transaction ID*
     
     the transactions which are newer than the referenced transaction will be returned in the response. The exact meaning of newer depends on the value of since_type
     
     *ISO date*
     
     the transactions which were booked on or after this date will be returned in the response
     */
    public var since: String?
    
    /**
     **optional** This parameter defines how the parameter since will be interpreted.
     
     *booked (the default)*
     
     the value of the parameter since will be compared to the booking date of the transaction.
     
     *created*
     
     the value of the parameter since will be compared to the creation time of the transaction on the figo Connect server
     
     *modified*
     
     the value of the parameter since will be compared to the last modification time of the transaction on the figo Connect server. The response parameter transactions will contain not only newly created transactions but also modified transactions. The response parameter deleted will contain a list of removed transactions.
     */
    public var sinceType: TransactionSinceType?
    
    /// **optional** Return only transactions which were booked on or before this date. Please provide as ISO date
    public var until: String?
    
    /// **optional** Filter expression to narrow down the returned transactions
    public var filter: String?
    
    /// **optional** Limit the number of returned transactions. In combination with the start_id parameter this can be used to paginate the result list. (default: 1000)
    public var count: Int?
    
    /// **optional** Offset into the implicit list of transactions used as starting point for the returned transactions. In combination with the count parameter this can be used to paginate the result list.
    public var offset: Int?
    
    /// **optional** This flag indicates whether pending transactions should be included in the response. Pending transactions are always included as a complete set, regardless of the since parameter. Before caching a copy of the pending transactions, all existing pending transactions for the same account must be removed from the local cache. (Default Value: false)
    public var includePending: Bool?
    
    /// **optional** This flag indicates whether statistics over the filtered transaction list should returned alongside the actual transactions. These statistics are always computed on the complete filtered transaction list, i.e. without count and offset. (Default Value: false)
    public var includeStatistics: Bool?
    
    /// **optional** If true, the balance will be shown in cents
    internal let cents: Bool = true
    
    /// **optional** A list of transactions types which the transactions are filtered by.
    public var type: [String]?
    

    public init(accounts: [String]? = nil, since: String? = nil, sinceType: TransactionSinceType? = nil, until: String? = nil, filter: String? = nil, count: Int? = nil, offset: Int? = nil, includePending: Bool? = nil, includeStatistics: Bool? = nil, type: [String]? = nil) {
        self.accounts = accounts
        self.since = since
        self.sinceType = sinceType
        self.until = until
        self.filter = filter
        self.count = count
        self.offset = offset
        self.includePending = includePending
        self.includeStatistics = includeStatistics
        self.type = type
    }
    
    var JSONObject: [String: AnyObject] {
        var dict = Dictionary<String, AnyObject>()
        dict["accounts"] = accounts as AnyObject?
        dict["since"] = since as AnyObject?
        dict["since_type"] = sinceType?.rawValue as AnyObject?
        dict["until"] = until as AnyObject?
        dict["filter"] = filter as AnyObject?
        dict["count"] = count as AnyObject?
        dict["offset"] = offset as AnyObject?
        dict["include_pending"] = includePending as AnyObject?
        dict["include_statistics"] = includeStatistics as AnyObject?
        dict["cents"] = cents as AnyObject?
        dict["type"] = type as AnyObject?
        return dict
    }
}


