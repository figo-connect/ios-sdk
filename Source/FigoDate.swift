//
//  FigoDate.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


/// Provides a NSDate representation for the server's timestamps
public struct FigoDate: UnboxableByTransform, CustomStringConvertible {
    
    public typealias UnboxRawValue = String

    public let date: Foundation.Date
    public let timestamp: String
    public var formattedShort: String
    public var formattedLong: String

    init() {
        self.date = Foundation.Date.distantPast
        self.timestamp = ""
        self.formattedShort = "Invalid date"
        self.formattedLong = "Invalid date"
    }
    
    init? (timestamp: String) {
        if let date = FigoDate.posixFormatter.date(from: timestamp) {
            self.date = date
            self.timestamp = timestamp
            self.formattedShort = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
            self.formattedLong = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .medium)
        }
        else {
            return nil
        }
    }
    
    static func transformUnboxedValue(_ unboxedValue: String) -> FigoDate? {
        return FigoDate(timestamp: unboxedValue)
    }
    
    public static func transform(unboxedValue: String) -> FigoDate? {
        return FigoDate(timestamp: unboxedValue)
    }
    
    static func unboxFallbackValue() -> FigoDate {
        return FigoDate()
    }
    
    fileprivate static let posixFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "Europe/Berlin")
        return formatter
    }()
    
    public var description: String {
        return self.formattedLong
    }
}

