//
//  Resources.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//

import Foundation


enum Resources: String {

    case Account
    case Balance
    case TanScheme
    case SyncStatus
    case User
    case PaymentParametersIntTextKeys
    case PaymentParametersStringTextKeys
    case TaskState
    case SupportedBanks
    case Transaction
    case Security
    case StandingOrder
    
    var JSONObject: [String: AnyObject] {
        let JSON: [String: AnyObject] = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
        return JSON
    }
    
    var data: Data {
        let bundle = Bundle(for: BaseTestCaseWithLogin.classForCoder())
        let path = bundle.path(forResource: self.rawValue, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        return data
    }
}

func nearlyEqual(_ a: Float, b: Float, epsilon: Float = 0.0001) -> Bool {
    return a - b < epsilon && b - a < epsilon
}

