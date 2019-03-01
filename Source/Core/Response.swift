//
//  Responses.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//

import Foundation


internal func decodeVoidResponse(_ response: FigoResult<Data>) -> FigoResult<Void> {
    switch response {
    case .failure(let error):
        return .failure(error)
    case .success:
        return .success(())
    }
}

internal func decodeUnboxableResponse<T: Unboxable>(_ data: FigoResult<Data>, context: Any? = nil) -> FigoResult<T> {
    switch data {
    case .success(let data):
        do {
            let unboxed: T = try unbox(data: data)
            return .success(unboxed)
        } catch (let error as UnboxError) {
            return .failure(FigoError(error: .unboxingError(error.description)))
        } catch {
            return .failure(FigoError(error: .unboxingError("Unboxer did throw unexpected error while unboxing object of type \(T.self)")))
        }
    case .failure(let error):
        return .failure(error)
    }
}

internal func decodeUnboxableResponse<T: Unboxable>(_ data: FigoResult<Data>, context: Any? = nil) -> FigoResult<[T]> {
    switch data {
    case .success(let data):
        do {
            let unboxed: [T] = try unbox(data: data)
            return .success(unboxed)
        } catch (let error as UnboxError) {
            return .failure(FigoError(error: .unboxingError(error.description)))
        } catch {
            return .failure(FigoError(error: .unboxingError("Unboxer did throw unexpected error while unboxing collection of type \(T.self)")))
        }
    case .failure(let error):
        return .failure(error)
    }
}

internal func base64EncodeBasicAuthCredentials(_ clientID: String, _ clientSecret: String) -> String {
    let clientCode: String = clientID + ":" + clientSecret
    let utf8str: Data = clientCode.data(using: String.Encoding.utf8)!
    return utf8str.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithCarriageReturn)
}
