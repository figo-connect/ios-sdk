//
//  Endpoint.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Alamofire




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
    case CreateNewFigoUser(user: NewUser, secret: String)
    case SetupNewAccount(NewAccount)
    case PollTaskState(PollTaskStateParameters)
    
    private var method: Alamofire.Method {
        switch self {
        case .LoginUser, .RefreshToken, .CreateNewFigoUser, .RevokeToken, .SetupNewAccount, .PollTaskState:
            return .POST
        default:
            return .GET
        }
    }
    
    private var path: String {
        switch self {
        case .LoginUser, .RefreshToken:
            return "/auth/token"
        case .RevokeToken:
            return "/auth/revoke"
        case .RetrieveAccount(let accountId):
            return "/rest/accounts/" + accountId
        case .RetrieveAccounts, .SetupNewAccount:
            return "/rest/accounts"
        case .RetrieveCurrentUser, .CreateNewFigoUser:
            return "/rest/user"
        case .PollTaskState:
            return "/task/progress"
        }
    }
    
    private var parameters: [String : AnyObject]? {
        switch self {
        case .LoginUser(let username, let password, _):
            return ["username": username, "password": password, "grant_type": "password"]
        case .RefreshToken(let token, _):
            return ["refresh_token": token, "grant_type": "refresh_token"]
        case .RevokeToken(let token):
            return ["token": token, "cascade": false]
        case .CreateNewFigoUser(let user, _):
            return user.JSONObject
        case .SetupNewAccount(let account):
            return account.JSONObject
        case .PollTaskState(let parameters):
            return parameters.JSONObject
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
        
        if let token = Session.sharedInstance.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            debugPrint("Bearer has been set")
        } else {
            debugPrint("❗️Failed to set Bearer due to missing access token")
        }
        
        switch self {
        case .LoginUser(_, _, let secret):
            addSecretToHeader(secret, request)
            break
        case .RefreshToken(_, let secret):
            addSecretToHeader(secret, request)
            break
        case .RevokeToken(_):
            addSecretToHeader(Session.sharedInstance.secret ?? "", request)
            break
        case .CreateNewFigoUser(_, let secret):
            addSecretToHeader(secret, request)
            break
        default:
            break
        }
        
        return self.encodeParameters(request)
    }
    
    private func addSecretToHeader(secret: String, _ request: NSMutableURLRequest) {
        request.setValue("Basic \(secret)", forHTTPHeaderField: "Authorization")
        debugPrint("Basic has been set")
    }
}

