//
//  StandingOrder.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public enum StandingOrderInterval: String, UnboxableEnum {
   
    case Weekly = "weekly"
    case Monthly = "monthly"
    case TwoMonthly = "two monthly"
    case Quarterly = "quarterly"
    case HalfYearly = "half yearly"
    case Yearly = "yearly"
    
    static func unboxFallbackValue() -> StandingOrderInterval {
        return .Monthly
    }
    
}


internal struct StandingOrderListEnvelope: Unboxable {
    
    let standingOrders: [StandingOrder]
    
    init(unboxer: Unboxer) {
        standingOrders = unboxer.unbox("standing_orders")
    }
}


/**

 Bank accounts can have standing orders associated with it if supported by the respective bank. In general the information provided for each standing order should be roughly similar to the content of the printed or online standing order statement available from the respective bank. Please note that not all banks provide the same level of detail.
 
 EXECUTION DAY AND INTERVAL
 
 When working with standing orders you have to take some characteristics into account. If a last_execution_date is set, the standing order has a limited term and will not run indefinitely.
 
 If you want to identify the next execution date you have to use the interval and execution_day parameters to calculate the next execution date. Interval defines the regular cycle the standing order gets executed. Possible values are: weekly, monthly, two monthly, quarterly, half yearly or yearly.
 
 On top of it the execution_day states the day of execution within the interval. This value depends on the interval chosen. 
 
 * If the interval is set to weekly, possible values for execution_day are: 00 (daily), 01 (monday), 02 (tuesday) … 07 (sunday).
 * If the interval is set to one of the other possible values, execution_day could be: 01 - 30 (1st day of the month to 30th day of the month), 97 (closing of the month - 2), 98(closing of the month - 1) or 99 (closing of the month)
 
 REQUEST STANDING ORDERS
 
 Standing orders aren’t requested by default when a new bank account is setup. Make sure to add the value “standingOrder” to the sync_tasks list

*/
public struct StandingOrder: Unboxable {

    /// Internal figo Connect standing order ID
    let standing_order_id: String
    
    /// Internal figo Connect account ID
    let account_id: String
    
    /// First execution date of the standing order
    let first_execution_date: String
    
    /// Last execution date of the standing order. This field might be emtpy, if no last execution date is set
    let last_execution_date: String?
    
    /// The day the standing order gets executed
    let execution_day: String
    
    /// The interval the standing order gets executed. Possible values are weekly, monthly, two monthly, quarterly, half yearly and yearly
    let interval: StandingOrderInterval
    
    /// Name of recipient
    let name: String
    
    /// Account number recipient
    let account_number: String
    
    /// Bank code of recipient
    let bank_code: String
    
    /// Bank name of recipient
    let bank_name: String
    
    /// Standing order amount in cents
    let amount: Int
    
    ///	Three-character currency code
    let currency: String
    
    /// Purpose text. This field might be empty if the standing order has no purpose.
    let purpose: String
    
    /// Internal creation timestamp on the figo Connect server
    let creation_timestamp: String
    
    /// Internal modification timestamp on the figo Connect server
    let modification_timestamp: String?
    
    
    init(unboxer: Unboxer) {
        standing_order_id = unboxer.unbox("standing_order_id")
        account_id = unboxer.unbox("account_id")
        first_execution_date = unboxer.unbox("first_execution_date")
        last_execution_date = unboxer.unbox("last_execution_date")
        execution_day = unboxer.unbox("execution_day")
        interval = unboxer.unbox("interval")
        name = unboxer.unbox("name")
        account_number = unboxer.unbox("account_number")
        bank_code = unboxer.unbox("bank_code")
        bank_name = unboxer.unbox("bank_name")
        amount = unboxer.unbox("amount")
        currency = unboxer.unbox("currency")
        purpose = unboxer.unbox("purpose")
        creation_timestamp = unboxer.unbox("creation_timestamp")
        modification_timestamp = unboxer.unbox("modification_timestamp")
    }
}
