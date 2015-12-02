//
//  FigoDate.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct FigoDate: UnboxableByTransform, CustomStringConvertible {
    
    internal typealias UnboxRawValueType = String
    
    public let date: NSDate
    public let timestamp: String
    public var description: String

    
    private init() {
        self.date = NSDate.distantPast()
        self.timestamp = ""
        self.description = "Invalid date"
    }
    
    private init? (timestamp: String) {
        if let date = FigoDate.posixFormatter.dateFromString(timestamp) {
            self.date = date
            self.timestamp = timestamp
            self.description = NSDateFormatter.localizedStringFromDate(date, dateStyle: .MediumStyle, timeStyle: .MediumStyle)
        }
        else {
            return nil
        }
    }
    
    static func transformUnboxedValue(unboxedValue: String) -> FigoDate? {
        return FigoDate(timestamp: unboxedValue)
    }
    
    static func unboxFallbackValue() -> FigoDate {
        return FigoDate()
    }
    
    private static let posixFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(name: "Europe/Berlin")
        return formatter
    }()
    
}

