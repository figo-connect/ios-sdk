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
    
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: Result<T, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            debugPrintRequest(request, response, data)
            
            switch result {
            case .Success(let value):
                do {
                    let responseObject = try T(response: response!, representation: value)
                    return .Success(responseObject!)
                }
                catch (SerializationError.MissingMandatoryKey(let key)) {
                    return .Failure(Error(code: .MissingJSONKey, failureReason: "Failed to created object \(T.self) from JSON because of missing key: \(key)"))
                }
                catch (SerializationError.UnexpectedType(let key)) {
                    return .Failure(Error(code: .UnexpectedJSONStructure, failureReason: "Failed to created object \(T.self) from JSON because of unexpected value type of key: \(key)"))
                }
                catch {
                    return .Failure(Error(code: .UnexpectedJSONStructure, failureReason: "Failed to created object \(T.self) from JSON: \(value)"))
                }
            case .Failure(let error):
                guard let data = data else { return .Failure(error) }
                guard let responseAsString = String(data: data, encoding: NSUTF8StringEncoding) else { return .Failure(error) }
                let errorWithResponseText = Error(code: Error.Code.UnrecognizedServerResponse, failureReason: responseAsString)
                guard let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) else { return .Failure(errorWithResponseText) }
                guard let errorWithServerMessage = try? Error(response: response!, representation: JSON) else { return .Failure(error) }
                return .Failure(errorWithServerMessage)
            }
        }
        
        return response(responseSerializer: responseSerializer) { (response: Response<T, NSError>) in
            switch response.result {
            case .Success(let value):
                completionHandler(Result.Success(value))
                break
            case .Failure(let error):
                completionHandler(Result.Failure(error))
                return
            }
        }
    }
    
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Result<[T], NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            debugPrintRequest(request, response, data)
            
            switch result {
            case .Success(let value):
                do {
                    let responseCollection = try T.collection(response: response!, representation: value)
                    return .Success(responseCollection)
                }
                catch (SerializationError.MissingMandatoryKey(let key)) {
                    return .Failure(Error(code: .MissingJSONKey, failureReason: "Failed to created object \(T.self) from JSON because of missing key: \(key)"))
                }
                catch (SerializationError.UnexpectedType(let key)) {
                    return .Failure(Error(code: .UnexpectedJSONStructure, failureReason: "Failed to created object \(T.self) from JSON because of unexpected value type of key: \(key)"))
                }
                catch {
                    return .Failure(Error(code: .UnexpectedJSONStructure, failureReason: "Failed to created object \(T.self) from JSON: \(value)"))
                }
            case .Failure(let error):
                guard let data = data else { return .Failure(error) }
                guard let responseAsString = String(data: data, encoding: NSUTF8StringEncoding) else { return .Failure(error) }
                let errorWithResponseText = Error(code: Error.Code.UnrecognizedServerResponse, failureReason: responseAsString)
                guard let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) else { return .Failure(errorWithResponseText) }
                guard let errorWithServerMessage = try? Error(response: response!, representation: JSON) else { return .Failure(error) }
                return .Failure(errorWithServerMessage)
            }
        }
        
        return response(responseSerializer: responseSerializer) { (response: Response<[T], NSError>) in
            switch response.result {
            case .Success(let value):
                completionHandler(Result.Success(value))
                break
            case .Failure(let error):
                completionHandler(Result.Failure(error))
                return
            }
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
