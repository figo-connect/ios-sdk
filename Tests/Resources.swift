//
//  Resources.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


enum Resources: String {

    case Account
    case Balance
    case TanScheme
    case SyncStatus
    
    var JSONObject: [String: AnyObject] {
        let bundle = NSBundle(forClass: BaseTestCaseWithLogin.classForCoder())
        let path = bundle.pathForResource(self.rawValue, ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let JSON: [String: AnyObject] = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
        return JSON
    }
}

func nearlyEqual(a: Float, b: Float, epsilon: Float = 0.0001) -> Bool {
    return a - b < epsilon && b - a < epsilon
}

func dateFromString(string: String) -> NSDate? {
    let formatter = NSDateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
    formatter.timeZone = NSTimeZone(name: "Europe/Berlin")
    return formatter.dateFromString(string)
}