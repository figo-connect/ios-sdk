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

internal protocol JSONObjectConvertible {
    var JSONObject: [String: AnyObject] { get }
}


internal enum Endpoint {
    
    private static let baseURLString = "https://api.figo.me"
    
    case CreateNewFigoUser(CreateUserParameters)
    case LoginUser(username: String, password: String)
    case DeleteCurrentUser
    case RetrieveCurrentUser
    
    case RefreshToken(String)
    case RevokeToken(String)
    
    case SetupAccount(CreateAccountParameters)
    case RetrieveAccounts
    case RetrieveAccount(String)
    case RemoveStoredPin(bankID: String)
    case DeleteAccount(String)
    
    case RetrieveLoginSettings(countryCode: String, bankCode: String)
    case RetrieveSupportedBanks(countryCode: String)
    case RetrieveSupportedServices(countryCode: String)

    case PollTaskState(PollTaskStateParameters)
    case Synchronize([String: AnyObject])
    
    case RetrieveTransactions(RetrieveTransactionsParameters?)
    case RetrieveTransactionsForAccount(String, parameters: RetrieveTransactionsParameters?)
    case RetrieveTransaction(String)
    
    case RetrieveSecurities(RetrieveSecuritiesParameters?)
    case RetrieveSecuritiesForAccount(String, parameters: RetrieveSecuritiesParameters?)
    case RetrieveSecurity(String, accountID: String)
    
    case RetrieveStandingOrders
    case RetrieveStandingOrdersForAccount(String)
    case RetrieveStandingOrder(String)

    case RetrievePaymentProposals
    case RetrievePayments
    case RetrievePaymentsForAccount(String)
    case RetrievePayment(String, accountID: String)
    case CreatePayment(CreatePaymentParameters)
    case ModifyPayment(Payment)
    case SubmitPayment(Payment, tanSchemeID: String)


    private var method: Method {
        switch self {
        case .LoginUser, .RefreshToken, .CreateNewFigoUser, .RevokeToken, .SetupAccount, .PollTaskState, .RemoveStoredPin, .Synchronize, .CreatePayment, .SubmitPayment:
            return .POST
        case .DeleteCurrentUser, .DeleteAccount:
            return .DELETE
        case .ModifyPayment:
            return .PUT
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
        case .RetrieveAccounts, .SetupAccount:
            return "/rest/accounts"
        case .RetrieveCurrentUser, .DeleteCurrentUser:
            return "/rest/user"
        case .CreateNewFigoUser:
            return "/auth/user"
        case .PollTaskState:
            return "/task/progress"
        case .RemoveStoredPin(let bankId):
            return "/rest/banks/\(bankId)/remove_pin"
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
        case .RetrieveSecurity(let securityID, let accountID):
            return "/rest/accounts/\(accountID)/securities/\(securityID)"
        case .RetrieveStandingOrders:
            return "/rest/standing_orders"
        case .RetrieveStandingOrdersForAccount(let accountID):
            return "/rest/accounts/\(accountID)/standing_orders"
        case .RetrieveStandingOrder(let standingOrderID):
            return "/rest/standing_orders/\(standingOrderID)"
        case .CreatePayment(let parameters):
            return "/rest/accounts/\(parameters.accountID)/payments"
        case .ModifyPayment(let payment):
            return "/rest/accounts/\(payment.accountID)/payments/\(payment.paymentID)"
        case .SubmitPayment(let payment, _):
            return "/rest/accounts/\(payment.accountID)/payments/\(payment.paymentID)/submit"
        case .RetrievePaymentProposals:
            return "/rest/address_book"
        case .RetrievePayments:
            return "/rest/payments"
        case .RetrievePaymentsForAccount(let accountID):
            return "/rest/accounts/\(accountID)/payments"
        case .RetrievePayment(let paymentID, let accountID):
            return "/rest/accounts/\(accountID)/payments/\(paymentID)"
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
        case .SetupAccount(let account):
            return account.JSONObject
        case .PollTaskState(let parameters):
            return parameters.JSONObject
        case .RemoveStoredPin(let bankId):
            return ["bank_id": bankId]
        case .RetrieveAccount, .RetrieveAccounts:
            return ["cents": true]
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
        case .CreatePayment(let parameters):
            return parameters.JSONObject
        case .ModifyPayment(let parameters):
            return parameters.JSONObject
        case .SubmitPayment(_, let tanSchemeID):
            return ["tan_scheme_id": tanSchemeID, "state": NSUUID().UUIDString]

        default:
            return nil
        }
    }
    
    private func encodeParameters(request: NSMutableURLRequest) {
        switch self.method {
        case .POST, .PUT:
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
        let percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + queryStringForParameters(parameters)
        URLComponents.percentEncodedQuery = percentEncodedQuery
        request.URL = URLComponents.URL
    }
}

private func queryStringForParameters(parameters: [String: AnyObject]) -> String {
    var components: [(String, String)] = []
    for key in parameters.keys.sort(<) {
        components.append((key, "\(parameters[key]!)"))
    }
    return (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
}



