//
//  CreateUserParameters.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct CreateUserParameters: JSONObjectConvertible {
    
    /// First and last name
    public let name: String
    
    /// Email address; It must obey the figo username & password policy
    public let email: String
    
    /// New figo Account password; It must obey the figo username & password policy
    public let password: String
    
    /// This flag indicates whether the user has agreed to be contacted by email (optional)
    public let send_newsletter: Bool?
    
    /// Two-letter code of preferred language (optional, default: de)
    public let language: String?
    
    /// Base64 encoded email address of the user promoting the new user (optional)
    public let affiliate_user: String?
    
    /// Client ID of the figo Connect partner from which the user was redirected to the registration form (optional)
    public let affiliate_client_id: String?
    
    
    var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict["name"] = name
            dict["email"] = email
            dict["send_newsletter"] = send_newsletter
            dict["language"] = language
            dict["password"] = password
            dict["affiliate_user"] = affiliate_user
            dict["affiliate_client_id"] = affiliate_client_id
            return dict
        }
    }
}
