//
//  Decoder.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


func decodeTaskTokenResponse(response: FigoResult<NSData>) -> FigoResult<String> {
    switch response {
    case .Failure(let error):
        return .Failure(error)
    case .Success(let data):
        do {
            if let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject] {
                if let token: String = JSON["task_token"] as? String {
                    return .Success(token)
                }
            }
            return .Failure(.JSONMissingMandatoryValue(key: "task_token", typeName: ""))
        } catch (let error as NSError) {
            return .Failure(.JSONSerializationError(error: error))
        }
    }
}

func decodeJSONResponse(response: FigoResult<NSData>) -> FigoResult<UnboxableDictionary> {
    switch response {
    case .Failure(let error):
        return .Failure(error)
    case .Success(let data):
        do {
            if let JSON: [String: AnyObject] = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject] {
                return .Success(JSON)
            } else {
                return .Failure(.JSONUnexpectedRootObject(typeName: "JSONResponse"))
            }
        } catch (let error as NSError) {
            return .Failure(.JSONSerializationError(error: error))
        }
    }
}

func decodeVoidResponse(response: FigoResult<NSData>) -> FigoResult<Void> {
    switch response {
    case .Failure(let error):
        return .Failure(error)
    case .Success:
        return .Success()
    }
}

func decodeUnboxableResponse<T: Unboxable>(data: FigoResult<NSData>, context: Any? = nil) -> FigoResult<T> {
    switch data {
    case .Success(let data):
        do {
            let unboxed: T = try UnboxOrThrow(data)
            return .Success(unboxed)
        } catch (let error as UnboxError) {
            return .Failure(.UnboxingError(error.description))
        } catch {
            return .Failure(.UnboxingError("Unboxer did throw unexpected error while unboxing object of type \(T.self)"))
        }
    case .Failure(let error):
        return .Failure(error)
    }
}

func decodeUnboxableResponse<T: Unboxable>(data: FigoResult<NSData>, context: Any? = nil) -> FigoResult<[T]> {
    switch data {
    case .Success(let data):
        do {
            let unboxed: [T] = try UnboxOrThrow(data)
            return .Success(unboxed)
        } catch (let error as UnboxError) {
            return .Failure(.UnboxingError(error.description))
        } catch {
            return .Failure(.UnboxingError("Unboxer did throw unexpected error while unboxing collection of type \(T.self)"))
        }
    case .Failure(let error):
        return .Failure(error)
    }
}

func base64EncodeBasicAuthCredentials(clientID: String, _ clientSecret: String) -> String {
    let clientCode: String = clientID + ":" + clientSecret
    let utf8str: NSData = clientCode.dataUsingEncoding(NSUTF8StringEncoding)!
    return utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
}
