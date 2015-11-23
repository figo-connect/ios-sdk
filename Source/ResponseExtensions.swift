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
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}


public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}


extension Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: Result<T, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = Error.errorWithCode(.UnexpectedJSONStructure, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer) { (response: Response<T, NSError>) in
            switch response.result {
            case .Success(let value):
                completionHandler(Result.Success(value))
                break
            case .Failure(let error):
                let error = errorFromResponseData(response.data, frameworkError: error)
                completionHandler(Result.Failure(error))
                return
            }
        }
    }
}


extension Request {
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Response<[T], NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response
                {
                    return .Success(T.collection(response: response, representation: value))
                }
                else
                {
                    let failureReason = "Response collection could not be serialized due to nil response"
                    let error = Error.errorWithCode(.UnexpectedJSONStructure, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
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




