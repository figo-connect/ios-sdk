//
//  Responses.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


internal func decodeVoidResponse(response: Result<NSData>) -> Result<Void> {
    switch response {
    case .Failure(let error):
        return .Failure(error)
    case .Success:
        return .Success()
    }
}

internal func decodeUnboxableResponse<T: Unboxable>(data: Result<NSData>, context: Any? = nil) -> Result<T> {
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

internal func decodeUnboxableResponse<T: Unboxable>(data: Result<NSData>, context: Any? = nil) -> Result<[T]> {
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

internal func base64EncodeBasicAuthCredentials(clientID: String, _ clientSecret: String) -> String {
    let clientCode: String = clientID + ":" + clientSecret
    let utf8str: NSData = clientCode.dataUsingEncoding(NSUTF8StringEncoding)!
    return utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
}





