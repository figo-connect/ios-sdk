//
//  Date.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


/// Provides a NSDate representation for the server's timestamps
public struct Date: UnboxableByTransform, CustomStringConvertible {
    
    internal typealias UnboxRawValueType = String
    
    public let date: NSDate
    public let timestamp: String
    public var formatted: String

    private init() {
        self.date = NSDate.distantPast()
        self.timestamp = ""
        self.formatted = "Invalid date"
    }
    
    private init? (timestamp: String) {
        if let date = Date.posixFormatter.dateFromString(timestamp) {
            self.date = date
            self.timestamp = timestamp
            self.formatted = NSDateFormatter.localizedStringFromDate(date, dateStyle: .MediumStyle, timeStyle: .MediumStyle)
        }
        else {
            return nil
        }
    }
    
    static func transformUnboxedValue(unboxedValue: String) -> Date? {
        return Date(timestamp: unboxedValue)
    }
    
    static func unboxFallbackValue() -> Date {
        return Date()
    }
    
    private static let posixFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(name: "Europe/Berlin")
        return formatter
    }()
    
    public var description: String {
        return self.formatted
    }
    
}

