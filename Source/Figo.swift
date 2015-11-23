//
//  Figo.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Alamofire



public func login(username username: String, password: String, clientID: String, clientSecret: String, completionHandler: (result: Result<Authorization, NSError>) -> ()) {
    let route = Router.LoginUser(username: username, password: password, clientID: clientID, clientSecret: clientSecret)
    
    let h: (result: Result<Authorization, NSError>) -> () = { result in
        Router.OAuthToken = result.value?.access_token
        completionHandler(result: result)
    }
    
    Alamofire.request(route)
        .validate()
        .responseObject(h)
}


public func retrieveAccounts(completionHandler: (result: Result<[Account], NSError>) -> ()) {
    Alamofire.request(Router.RetrieveAccounts)
        .validate()
        .responseCollection(completionHandler)
}


public func retrieveAccount(accountID: String, completionHandler: (result: Result<Account, NSError>) -> ()) {
    Alamofire.request(Router.RetrieveAccount(accountId: accountID))
        .validate()
        .responseObject(completionHandler)
}


public enum Router: URLRequestConvertible {
    private static let baseURLString = "https://api.figo.me"
    private static var OAuthToken: String?
    
    case RefreshToken(token: String)
    case LoginUser(username: String, password: String, clientID: String, clientSecret: String)
    case RetrieveAccount(accountId: String)
    case RetrieveAccounts
    
    var method: Alamofire.Method {
        switch self {
            case .RefreshToken, LoginUser:
                return .POST
            default:
                return .GET
        }
    }
    
    var path: String {
        switch self {
            case .RefreshToken, LoginUser:
                return "/auth/token"
            case .RetrieveAccounts:
                return "/rest/accounts"
            case.RetrieveAccount(let accountId):
                return "/rest/accounts/" + accountId
        }
    }
    
    
    public var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        
        mutableURLRequest.HTTPMethod = method.rawValue

        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        mutableURLRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forKey: "Content-Type")


        // "device_name" : UIDevice.currentDevice().name, "device_type" : UIDevice.currentDevice().model, "device_udid" : NSUUID().UUIDString
        
        if let token = Router.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
            case .RefreshToken(let token):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["refresh_token": token]).0
                
            case .LoginUser(let username, let password, let clientID, let clientSecret):
                let clientCode: String = clientID + ":" + clientSecret
                let utf8str: NSData = clientCode.dataUsingEncoding(NSUTF8StringEncoding)!
                let base64Encoded: NSString = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
                mutableURLRequest.setValue("Basic \(base64Encoded)", forHTTPHeaderField: "Authorization")
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["username": username, "password" : password, "grant_type" : "password"]).0
            
            default:
                return mutableURLRequest
        }
    }
}

