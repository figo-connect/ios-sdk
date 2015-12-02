//
//  Endpoints.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


private enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

enum Endpoint {
    private static let baseURLString = "https://api.figo.me"
    
    case CreateNewFigoUser(user: CreateUserParameters)
    case LoginUser(username: String, password: String)
    case DeleteCurrentUser
    case RetrieveCurrentUser
    case RefreshToken(token: String)
    case RevokeToken(token: String)
    case SetupCreateAccountParameters(CreateAccountParameters)
    case RetrieveAccounts
    case RetrieveAccount(accountId: String)
    case RemoveStoredPin(bankId: String)
    case DeleteAccount(accountID: String)
    case RetrieveLoginSettings(countryCode: String, bankCode: String)
    case BeginTask(taskToken: String)
    case PollTaskState(PollTaskStateParameters)
    case RetrieveSupportedBanks(countryCode: String)
    case RetrieveSupportedServices(countryCode: String)
    case Synchronize(parameters: [String: AnyObject])
    case RetrieveTransactions(parameters: RetrieveTransactionsParameters?)
    case RetrieveTransactionsForAccount(accountID: String, parameters: RetrieveTransactionsParameters?)
    case RetrieveTransaction(transactionID: String)
    case RetrieveSecurities(parameters: RetrieveSecuritiesParameters?)
    case RetrieveSecuritiesForAccount(accountID: String, parameters: RetrieveSecuritiesParameters?)
    case RetrieveSecurity(accountID: String, securityID: String)
    
    private var method: Method {
        switch self {
        case .LoginUser, .RefreshToken, .CreateNewFigoUser, .RevokeToken, .SetupCreateAccountParameters, .PollTaskState, .RemoveStoredPin, .Synchronize:
            return .POST
        case .DeleteCurrentUser, .DeleteAccount:
            return .DELETE
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
        case .DeleteAccount(let accountId):
            return "/rest/accounts/" + accountId
        case .RetrieveAccounts, .SetupCreateAccountParameters:
            return "/rest/accounts"
        case .RetrieveCurrentUser, .DeleteCurrentUser:
            return "/rest/user"
        case .CreateNewFigoUser:
            return "/auth/user"
        case .PollTaskState:
            return "/task/progress"
        case .RemoveStoredPin(let bankId):
            return "/rest/banks/\(bankId)/remove_pin"
        case .BeginTask:
            return "/task/start"
        case .RetrieveLoginSettings(let countryCode, let bankCode):
            return "/rest/catalog/banks/\(countryCode)/\(bankCode)"
        case .RetrieveSupportedBanks(let countryCode):
            return "/rest/catalog/\(countryCode)"
        case .RetrieveSupportedServices(let countryCode):
            return "/rest/catalog/services/\(countryCode)"
        case .Synchronize:
            return "/rest/sync"
        case .RetrieveTransactions:
            return "/rest/transactions"
        case .RetrieveTransactionsForAccount(let accountID, _):
            return "/rest/accounts/\(accountID)/transactions"
        case .RetrieveTransaction(let transactionID):
            return "/rest/transactions/\(transactionID)"
        case .RetrieveSecurities:
            return "/rest/securities"
        case .RetrieveSecuritiesForAccount(let accountID, _):
            return "/rest/accounts/\(accountID)/securities"
        case .RetrieveSecurity(let accountID, let securityID):
            return "/rest/accounts/\(accountID)/securities/\(securityID)"
        }
    }
    
    private var parameters: [String: AnyObject]? {
        switch self {
        case .LoginUser(let username, let password):
            return ["username": username, "password": password, "grant_type": "password"]
        case .RefreshToken(let token):
            return ["refresh_token": token, "grant_type": "refresh_token"]
        case .RevokeToken(let token):
            return ["token": token, "cascade": false]
        case .CreateNewFigoUser(let user):
            return user.JSONObject
        case .SetupCreateAccountParameters(let account):
            return account.JSONObject
        case .PollTaskState(let parameters):
            return parameters.JSONObject
        case .RemoveStoredPin(let bankId):
            return ["bank_id": bankId]
        case .RetrieveAccount, .RetrieveAccounts:
            return ["cents": true]
        case .BeginTask(let taskToken):
            return ["id": taskToken]
        case .Synchronize(let parameters):
            return parameters
        case .RetrieveTransactions(let parameters):
            return parameters?.JSONObject
        case .RetrieveTransactionsForAccount(_, let parameters):
            return parameters?.JSONObject
        case .RetrieveTransaction:
            return ["cents" : true]
        case .RetrieveSecurities(let parameters):
            return parameters?.JSONObject
        case .RetrieveSecuritiesForAccount(_, let parameters):
            return parameters?.JSONObject
        case .RetrieveSecurity:
            return ["cents" : true]
        default:
            return nil
        }
    }
    
    private func encodeParameters(request: NSMutableURLRequest) {
        switch self.method {
        case .POST:
            if case .PollTaskState(let parameters) = self {
                encodeURLParameters(request, ["id": parameters.taskToken])
            }
            guard let parameters = self.parameters else { return }
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(parameters, options: [.PrettyPrinted])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = data
            } catch { }
            break
        case .GET, .DELETE:
            encodeURLParameters(request, parameters)
            break
        default:
            break
        }
    }
    
    var needsBasicAuthHeader: Bool {
        switch self {
        case .LoginUser, .RefreshToken, .RevokeToken, .CreateNewFigoUser:
            return true
        default:
            return false
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Endpoint.baseURLString)!
        let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        request.HTTPMethod = self.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        encodeParameters(request)
        return request
    }
}



private func encodeURLParameters(request: NSMutableURLRequest, _ parameters: [String: AnyObject]?) {
    guard let parameters = parameters else { return }
    guard parameters.count > 0 else { return }
    
    if let URLComponents = NSURLComponents(URL: request.URL!, resolvingAgainstBaseURL: false) {
        let percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
        URLComponents.percentEncodedQuery = percentEncodedQuery
        request.URL = URLComponents.URL
    }
}

private func query(parameters: [String: AnyObject]) -> String {
    var components: [(String, String)] = []
    for key in parameters.keys.sort(<) {
        components.append((key, "\(parameters[key]!)"))
    }
    return (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
}



