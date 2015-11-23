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
            
            debugPrintRequest(request)
            debugPrintResponse(response)
            debugPrintData(data)
            debugPrint(error)
            
            guard let response = response else { return .Failure(error!) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                guard error == nil else {
                    return .Failure(Error(response: response, representation: value))
                }
                if let responseObject = T(response: response, representation: value) {
                    return .Success(responseObject)
                } else {
                    return .Failure(Error(code: .UnexpectedJSONStructure, failureReason: "Failed to created object \(T.self) from JSON: \(value)"))
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
                completionHandler(Result.Failure(error))
                return
            }
        }
    }
    

    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Result<[T], NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in

            debugPrintRequest(request)
            debugPrintResponse(response)
            debugPrintData(data)
            debugPrint(error)
            
            guard let response = response else { return .Failure(error!) }
        
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                guard error == nil else {
                    return .Failure(Error(response: response, representation: value))
                }
                return .Success(T.collection(response: response, representation: value))

            case .Failure(let error):
                return .Failure(error)
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


private func debugPrintRequest(request: NSURLRequest?) {
    if let request = request {
        debugPrint(request)
        if let data = request.HTTPBody {
            if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
                debugPrint(JSON)
            }
        }
    }
}

private func debugPrintResponse(response: NSHTTPURLResponse?) {
    if let response = response {
        debugPrint(response)
    }
}


private func debugPrintData(data: NSData?) {
    if let data = data {
        if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
            debugPrint(JSON)
        }
    }
}



