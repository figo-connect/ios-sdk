//
//  Endpoints.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Alamofire


func fireRequest(request: URLRequestConvertible) -> Request {
    return Alamofire.request(request).validate()
}

func base64Encode(clientID: String, _ clientSecret: String) -> String {
    let clientCode: String = clientID + ":" + clientSecret
    let utf8str: NSData = clientCode.dataUsingEncoding(NSUTF8StringEncoding)!
    return utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
}

enum Endpoint: URLRequestConvertible {
    private static let baseURLString = "https://api.figo.me"
    
    case LoginUser(username: String, password: String, secret: String)
    case RefreshToken(token: String, secret: String)
    case RevokeToken(token: String)
    case RetrieveAccount(accountId: String)
    case RetrieveAccounts
    case RetrieveCurrentUser
    
    private var method: Alamofire.Method {
        switch self {
        case .LoginUser, .RefreshToken:
            return .POST
        default:
            return .GET
        }
    }
    
    private var path: String {
        switch self {
            case .LoginUser, .RefreshToken:
                return "/auth/token"
            case .RevokeToken(_):
                return "/auth/revoke"
            case .RetrieveAccount(let accountId):
                return "/rest/accounts/" + accountId
            case .RetrieveAccounts:
                return "/rest/accounts"
            case .RetrieveCurrentUser:
                return "/rest/user"
        }
    }
    
    private var parameters: [String : AnyObject]? {
        switch self {
        case .LoginUser(let username, let password, _):
            return ["username": username, "password": password, "grant_type": "password"]
        case .RefreshToken(let token, _):
            return ["refresh_token": token, "grant_type": "refresh_token"]
        case .RevokeToken(let token):
            return ["token": token]
        default:
            return nil
        }
    }
    
    private func encodeParameters(request: NSMutableURLRequest) -> NSMutableURLRequest {
        switch self.method {
            case .GET:
                return Alamofire.ParameterEncoding.URL.encode(request, parameters: parameters).0
            default:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                return Alamofire.ParameterEncoding.JSON.encode(request, parameters: parameters).0
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Endpoint.baseURLString)!
        let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        
        request.HTTPMethod = self.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = Session.sharedSession.authorization?.access_token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .LoginUser(_, _, let secret):
            request.setValue("Basic \(secret)", forHTTPHeaderField: "Authorization")
            break
        case .RefreshToken(_, let secret):
            request.setValue("Basic \(secret)", forHTTPHeaderField: "Authorization")
            break
        default:
            break
        }
        
        return self.encodeParameters(request)
    }
}

