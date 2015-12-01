//
//  CreateSyncTaskParameters.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


/**
 Parameters for the CREATE NEW SYNCHRONIZATION TASK endpoint
 */
public struct CreateSyncTaskParameters: JSONObjectConvertible {
    
    //// (optional) This flag indicates whether notifications should be sent to your application. Since your application will be notified by the callback URL anyway, you might want to disable any additional notifications.
    let disable_notifications: Bool?
    
    /// (optional) If this parameter is set, only those accounts will be synchronized, which have not been synchronized within the specified number of minutes.
    public let if_not_synced_since: Int?
    
    /// Any kind of string that will be forwarded in the callback response message. It serves two purposes: The value is used to maintain state between this request and the callback, e.g. it might contain a session ID from your application. The value should also contain a random component, which your application checks to mitigate cross-site request forgery.
    let state: String
    
    /// (optional) Automatically acknowledge and ignore any errors (default: false)
    public let auto_continue: Bool?
    
    /// (optional) Only sync the accounts with these IDs
    public let account_ids: [String]?
    
    /// (optional) List of additional information to be fetched from the bank. Possible values are: standingOrders
    public let sync_tasks: [String]?
    
    
    public init () {
        self.init(ifNotSyncedSince: nil, autoContinue: false, accountIDs: nil, syncTasks: nil)
    }
    
    /**
     - Parameter ifNotSyncedSince: (optional) If this parameter is set, only those accounts will be synchronized, which have not been synchronized within the specified number of minutes.
     - Parameter autoContinue: (optional) Automatically acknowledge and ignore any errors (default: false)
     - Parameter accountIDs: (optional) Only sync the accounts with these IDs
     - Parameter syncTasks: (optional) List of additional information to be fetched from the bank. (Possible values are: standingOrders)
     */
    public init(ifNotSyncedSince: Int?, autoContinue: Bool? = false, accountIDs: [String]?, syncTasks: [String]?){
        disable_notifications = nil
        if_not_synced_since = ifNotSyncedSince
        auto_continue = autoContinue
        account_ids = accountIDs
        sync_tasks = syncTasks
        state = NSUUID().UUIDString
    }
    
    var JSONObject: [String: AnyObject] {
        var dict = Dictionary<String, AnyObject>()
        dict["disable_notifications"] = disable_notifications
        dict["if_not_synced_since"] = if_not_synced_since
        dict["state"] = state
        dict["auto_continue"] = auto_continue
        dict["account_ids"] = account_ids
        dict["sync_tasks"] = sync_tasks
        return dict
    }
}
