//
//  ResponseObjectSerializable.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Alamofire


public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject) throws
}


public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) throws -> [Self]
}


extension Request {
    
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (T?, FigoError?) -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, FigoError> { request, response, data, error in
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            debugPrintRequest(request, response, data)
            
            switch result {
            case .Success(let value):
                do {
                    let responseObject = try T(response: response!, representation: value)
                    return .Success(responseObject!)
                }
                catch (FigoError.JSONMissingMandatoryKey(let key, let object)) {
                    return .Failure(FigoError.JSONMissingMandatoryKey(key: key, object: object))
                }
                catch (FigoError.JSONUnexpectedType(let key, let object)) {
                    return .Failure(FigoError.JSONUnexpectedType(key: key, object: object))
                }
                catch {
                    return .Failure(FigoError.JSONUnexpectedRootObject(object: "\(T.self)"))
                }
            case .Failure(let error):
                guard let data = data else { return .Failure(FigoError.NetworkLayerError(error: error)) }
                guard let responseAsString = String(data: data, encoding: NSUTF8StringEncoding) else { return .Failure(FigoError.NetworkLayerError(error: error)) }
                guard let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) else { return .Failure(FigoError.ServerError(message: responseAsString)) }
                guard let serverError = try? FigoError(response: response!, representation: JSON) else { return .Failure(FigoError.ServerError(message: responseAsString)) }
                return .Failure(serverError)
            }
        }
        
        return response(responseSerializer: responseSerializer) { (response: Response<T, FigoError>) in
            completionHandler(response.result.value, response.result.error)
        }
    }
    
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: ([T]?, FigoError?) -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], FigoError> { request, response, data, error in
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            debugPrintRequest(request, response, data)
            
            switch result {
            case .Success(let value):
                do {
                    let responseCollection = try T.collection(response: response!, representation: value)
                    return .Success(responseCollection)
                }
                catch (FigoError.JSONMissingMandatoryKey(let key, let object)) {
                    return .Failure(FigoError.JSONMissingMandatoryKey(key: key, object: object))
                }
                catch (FigoError.JSONUnexpectedType(let key, let object)) {
                    return .Failure(FigoError.JSONUnexpectedType(key: key, object: object))
                }
                catch {
                    return .Failure(FigoError.JSONUnexpectedRootObject(object: "\(T.self)"))
                }
            case .Failure(let error):
                guard let data = data else { return .Failure(FigoError.NetworkLayerError(error: error)) }
                guard let responseAsString = String(data: data, encoding: NSUTF8StringEncoding) else { return .Failure(FigoError.NetworkLayerError(error: error)) }
                guard let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) else { return .Failure(FigoError.ServerError(message: responseAsString)) }
                guard let serverError = try? FigoError(response: response!, representation: JSON) else { return .Failure(FigoError.ServerError(message: responseAsString)) }
                return .Failure(serverError)
            }
        }
        
        return response(responseSerializer: responseSerializer) { (response: Response<[T], FigoError>) in
            completionHandler(response.result.value, response.result.error)
        }
    }
}


private func debugPrintRequest(request: NSURLRequest?, _ response: NSHTTPURLResponse?, _ data: NSData?) {
    if let request = request {
        debugPrint(request)
        if let fields = request.allHTTPHeaderFields {
            for (key, value) in fields {
                debugPrint(key + ": " + value)
            }
        }
        if let data = request.HTTPBody {
            if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
                debugPrint(JSON)
            }
        }
    }
    if let response = response {
        debugPrint(response)
    }
    if let data = data {
        if let string = String(data: data, encoding: NSUTF8StringEncoding) {
            if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
                debugPrint(JSON)
            } else {
                debugPrint(string)
            }
        }
    }
}
