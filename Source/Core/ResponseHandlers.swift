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
    init(response: NSHTTPURLResponse, representation: AnyObject) throws
}


public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) throws -> [Self]
}


extension Request {
    
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (T?, Error?) -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, Error> { request, response, data, error in
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            debugPrintRequest(request, response, data)
            
            switch result {
            case .Success(let value):
                do {
                    let responseObject = try T(response: response!, representation: value)
                    return .Success(responseObject)
                }
                catch (let error as Error) {
                    return .Failure(error)
                }
                catch {
                    return .Failure(Error.UnspecifiedError)
                }
            case .Failure(let error):
                guard let data = data else { return .Failure(Error.NetworkLayerError(error: error)) }
                guard let responseAsString = String(data: data, encoding: NSUTF8StringEncoding) else { return .Failure(Error.NetworkLayerError(error: error)) }
                guard let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) else { return .Failure(Error.ServerError(message: responseAsString)) }
                guard let serverErrorWithDescription = try? Error(response: response!, representation: JSON) else { return .Failure(Error.ServerError(message: responseAsString)) }
                return .Failure(serverErrorWithDescription)
            }
        }
        
        return response(responseSerializer: responseSerializer) { (response: Response<T, Error>) in
            completionHandler(response.result.value, response.result.error)
        }
    }
    
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: (Array<T>?, Error?) -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], Error> { request, response, data, error in
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            debugPrintRequest(request, response, data)
            
            switch result {
            case .Success(let value):
                do {
                    let responseCollection = try T.collection(response: response!, representation: value)
                    return .Success(responseCollection)
                }
                catch (let error as Error) {
                    return .Failure(error)
                }
                catch {
                    return .Failure(Error.UnspecifiedError)
                }
            case .Failure(let error):
                guard let data = data else { return .Failure(Error.NetworkLayerError(error: error)) }
                guard let responseAsString = String(data: data, encoding: NSUTF8StringEncoding) else { return .Failure(Error.NetworkLayerError(error: error)) }
                guard let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) else { return .Failure(Error.ServerError(message: responseAsString)) }
                guard let serverErrorWithDescription = try? Error(response: response!, representation: JSON) else { return .Failure(Error.ServerError(message: responseAsString)) }
                return .Failure(serverErrorWithDescription)
            }
        }
        
        return response(responseSerializer: responseSerializer) { (response: Response<[T], Error>) in
            completionHandler(response.result.value, response.result.error)
        }
    }
}


