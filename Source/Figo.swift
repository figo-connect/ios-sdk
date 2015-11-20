//
//  Figo.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Alamofire


public enum Result<T> {
    case Success(T)
    case Failure(NSError)
}

func logResponse(response: Alamofire.Response<AnyObject, NSError>) {
    debugPrint(response.request!)
    if let data = response.request?.HTTPBody {
        if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
            debugPrint(JSON)
        }
    }

    debugPrint(response.response!)
    if let data = response.data {
        if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
            debugPrint(JSON)
        }
    }
}

public func login(username username: String, password: String, clientID: String, clientSecret: String, completionHandler: (result: Result<Authorization>) -> ()) {
    let route = Router.LoginUser(username: username, password: password, clientID: clientID, clientSecret: clientSecret)
    Alamofire.request(route)
        .validate()
        .responseJSON() { response in
            logResponse(response)
        }
        .responseObject { (response: Response<Authorization, NSError>) in
            switch response.result {
                case .Success(let value):
                    completionHandler(result: Result.Success(value))
                    break
                case .Failure(let error):
                    let error = errorFromResponseData(response.data, frameworkError: error)
                    completionHandler(result: Result.Failure(error))
                    return
            }
        }
}



public func retrieveAccounts(completionHandler: (result: Result<[Account]>) -> ()) {
    Alamofire.request(Router.RetrieveAccounts)
        .validate()
        .responseJSON() { response in
            logResponse(response)
        }
        .responseCollection { (response: Response<[Account], NSError>) in
            switch response.result {
            case .Success(let value):
                completionHandler(result: Result.Success(value))
                break
            case .Failure(let error):
                let error = errorFromResponseData(response.data, frameworkError: error)
                completionHandler(result: Result.Failure(error))
                return
            }
    }
}


public enum Retrieve {
    case Accounts
}


func errorFromResponseData(data: NSData?, frameworkError: NSError) -> NSError {
    if let data = data {
        if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
            if let JSON = JSON as? [String: AnyObject] {
                let error = Error.errorWithCode(.ServerErrorResponse, failureReason: JSON["error_description"] as! String)
                return error
            }
        }
    }
    return frameworkError
}



public enum Router: URLRequestConvertible {
    private static let baseURLString = "https://api.figo.me"
    private static var OAuthToken: String? = "ASHWLIkouP2O6_bgA2wWReRhletgWKHYjLqDaqb0LFfamim9RjexTo22ujRIP_cjLiRiSyQXyt2kM1eXU2XLFZQ0Hro15HikJQT_eNeT_9XQ"
    
    case RefreshToken(token: String)
    case LoginUser(username: String, password: String, clientID: String, clientSecret: String)
    case RetrieveAccount(accountId: String, handler: (result: Result<Account>) -> ())
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
            case.RetrieveAccount(let accountId, _):
                return "/rest/accounts/" + accountId
        }
    }
    
    public var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        
        mutableURLRequest.HTTPMethod = method.rawValue
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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

