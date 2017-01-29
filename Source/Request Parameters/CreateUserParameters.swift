//
//  CreateUserParameters.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//


/**

Parameters for the endpoint CREATE NEW FIGO USER

- Parameter name: **required** First and last name
- Parameter email: **required** Email address; It must obey the figo username & password policy
- Parameter password: **required** New figo Account password; It must obey the figo username & password policy
- Parameter sendNewsletter: **optional** This flag indicates whether the user has agreed to be contacted by email (optional)
- Parameter language: **optional** Two-letter code of preferred language (default: de)

*/
public struct CreateUserParameters: JSONObjectConvertible {
    
    /// **required** First and last name
    public let name: String
    
    /// **required** Email address; It must obey the figo username & password policy
    public let email: String
    
    /// **required** New figo Account password; It must obey the figo username & password policy
    public let password: String
    
    /// **optional** This flag indicates whether the user has agreed to be contacted by email
    public let sendNewsletter: Bool?
    
    /// **optional** Two-letter code of preferred language (default: de)
    public let language: String?
    

    public init(name: String, email: String, password: String, sendNewsletter: Bool? = false, language: String? = "de") {
        self.name = name
        self.email = email
        self.password = password
        self.sendNewsletter = sendNewsletter
        self.language = language
    }
    
    var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict["name"] = name as AnyObject?
            dict["email"] = email as AnyObject?
            dict["send_newsletter"] = sendNewsletter as AnyObject?
            dict["language"] = language as AnyObject?
            dict["password"] = password as AnyObject?
            return dict
        }
    }
}
