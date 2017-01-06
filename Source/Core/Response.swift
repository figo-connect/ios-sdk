//
//  Responses.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Unbox


internal func decodeVoidResponse(_ response: Result<Data>) -> Result<Void> {
    switch response {
    case .failure(let error):
        return .failure(error)
    case .success:
        return .success()
    }
}

internal func decodeUnboxableResponse<T: Unboxable>(_ data: Result<Data>, context: Any? = nil) -> Result<T> {
    switch data {
    case .success(let data):
        do {
            let unboxed: T = try unbox(data: data)
            return .success(unboxed)
        } catch (let error as UnboxError) {
            return .failure(.unboxingError(error.description))
        } catch {
            return .failure(.unboxingError("Unboxer did throw unexpected error while unboxing object of type \(T.self)"))
        }
    case .failure(let error):
        return .failure(error)
    }
}

internal func decodeUnboxableResponse<T: Unboxable>(_ data: Result<Data>, context: Any? = nil) -> Result<[T]> {
    switch data {
    case .success(let data):
        do {
            let unboxed: [T] = try unbox(data: data)
            return .success(unboxed)
        } catch (let error as UnboxError) {
            return .failure(.unboxingError(error.description))
        } catch {
            return .failure(.unboxingError("Unboxer did throw unexpected error while unboxing collection of type \(T.self)"))
        }
    case .failure(let error):
        return .failure(error)
    }
}

internal func base64EncodeBasicAuthCredentials(_ clientID: String, _ clientSecret: String) -> String {
    let clientCode: String = clientID + ":" + clientSecret
    let utf8str: Data = clientCode.data(using: String.Encoding.utf8)!
    return utf8str.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
}
