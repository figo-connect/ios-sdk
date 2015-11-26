//
//  NewUser.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct NewUser: JSONObjectConvertible {
    
    /// First and last name
    public var name: String
    
    /// Email address; It must obey the figo username & password policy
    public var email: String
    
    /// New figo Account password; It must obey the figo username & password policy
    public var password: String
    
    /// This flag indicates whether the user has agreed to be contacted by email (optional)
    public var send_newsletter: Bool?
    
    /// Two-letter code of preferred language (optional, default: de)
    public var language: String?
    
    /// Base64 encoded email address of the user promoting the new user (optional)
    public var affiliate_user: String?
    
    /// Client ID of the figo Connect partner from which the user was redirected to the registration form (optional)
    public var affiliate_client_id: String?

    
    private enum Key: String, PropertyKey {
        case name
        case email
        case send_newsletter
        case language
        case password
        case affiliate_user
        case affiliate_client_id
    }
    
    public init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    public var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict[Key.name.rawValue] = name
            dict[Key.email.rawValue] = email
            dict[Key.send_newsletter.rawValue] = send_newsletter
            dict[Key.language.rawValue] = language
            dict[Key.password.rawValue] = password
            dict[Key.affiliate_user.rawValue] = affiliate_user
            dict[Key.affiliate_client_id.rawValue] = affiliate_client_id
            return dict
        }
    }
}