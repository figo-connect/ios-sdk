//
//  ResponseHandler.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Alamofire


func retryRequestingObjectOnInvalidTokenError<T: ResponseObjectSerializable>(request: URLRequestConvertible, _ object: T?, _ error: Error?, _ completionHandler: (T?, Error?) -> Void) {
    guard error != nil else {
        completionHandler(object, error)
        return
    }
    switch error! {
    case Error.ServerError(_):
        refreshAccessToken() { refreshError -> Void in
            if refreshError == nil {
                fireRequest(request).responseObject(completionHandler)
            } else {
                completionHandler(object, refreshError)
            }
        }
        return
    default:
        break
    }
    completionHandler(object, error)
}

func retryRequestingCollectionOnInvalidTokenError<T: ResponseCollectionSerializable>(request: URLRequestConvertible, _ collection: [T]?, _ error: Error?, _ completionHandler: ([T]?, Error?) -> Void) {
    guard error != nil else {
        completionHandler(collection, error)
        return
    }
    switch error! {
    case Error.ServerError(_):
        refreshAccessToken() { refreshError -> Void in
            if refreshError == nil {
                fireRequest(request).responseCollection(completionHandler)
            } else {
                completionHandler(collection, refreshError)
            }
        }
        return
    default:
        break
    }
    completionHandler(collection, error)
}


extension Request {
    
    func responseObject<T: ResponseObjectSerializable>(completionHandler: (T?, Error?) -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, Error> { request, response, data, error in
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            debugPrintRequest(request, response, data)

            switch result {
            case .Success(let value):
                do {
                    let responseObject = try T(representation: value)
                    return .Success(responseObject)
                }
                catch (let error as Error) {
                    return .Failure(error)
                }
                catch {
                    return .Failure(Error.UnspecifiedError(reason: "Internal inconsistency at \(__FILE__):\(__LINE__)"))
                }
            case .Failure(let error):
                guard let data = data else { return .Failure(Error.NetworkLayerError(error: error)) }
                guard let responseAsString = String(data: data, encoding: NSUTF8StringEncoding) else { return .Failure(Error.NetworkLayerError(error: error)) }
                guard let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) else { return .Failure(Error.ServerError(message: responseAsString)) }
                guard let serverErrorWithDescription = try? Error(representation: JSON) else { return .Failure(Error.ServerError(message: responseAsString)) }
                return .Failure(serverErrorWithDescription)
            }
        }
        
        return response(responseSerializer: responseSerializer) { (response: Response<T, Error>) in
            completionHandler(response.result.value, response.result.error)
        }
    }
    
    func responseCollection<T: ResponseCollectionSerializable>(completionHandler: (collection: [T]?, error: Error?) -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], Error> { request, response, data, error in
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            debugPrintRequest(request, response, data)
            
            switch result {
            case .Success(let value):
                do {
                    let responseCollection = try T.collection(value)
                    return .Success(responseCollection)
                }
                catch (let error as Error) {
                    return .Failure(error)
                }
                catch {
                    return .Failure(Error.UnspecifiedError(reason: "Internal inconsistency at \(__FILE__):\(__LINE__)"))
                }
            case .Failure(let error):
                guard let data = data else { return .Failure(Error.NetworkLayerError(error: error)) }
                guard let responseAsString = String(data: data, encoding: NSUTF8StringEncoding) else { return .Failure(Error.NetworkLayerError(error: error)) }
                guard let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) else { return .Failure(Error.ServerError(message: responseAsString)) }
                guard let serverErrorWithDescription = try? Error(representation: JSON) else { return .Failure(Error.ServerError(message: responseAsString)) }
                return .Failure(serverErrorWithDescription)
            }
        }
        
        return response(responseSerializer: responseSerializer) { (response: Response<[T], Error>) in
            completionHandler(collection: response.result.value, error: response.result.error)
        }
    }
}


