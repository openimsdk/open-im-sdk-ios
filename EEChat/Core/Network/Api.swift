//
//  Api.swift
//  OpenIM
//
//  Created by Snow on 2021/3/26.
//

import Foundation

public struct Response {
    public let code: Int
    public let message: String
    public var content: Any?
    public var refreshTag: String?
    public var rootKey: String?
}

public extension Response {
    
    func getDict() -> [String: Any] {
        return content as! [String: Any]
    }

    func getArray() -> [Any] {
        if let array = content as? [Any] {
            return array
        }
        if let dict = content as? [String: Any], let key = rootKey, let array = dict[key] as? [Any] {
            return array
        }
        return []
    }
    
    func getData() throws -> Data {
        assert(content != nil, "content != nil")
        if let data = content as? Data {
            return data
        }
        return try JSONSerialization.data(withJSONObject: content!, options: .fragmentsAllowed)
    }
    
    func getModel<ModeType: Decodable>(keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> ModeType {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        return try decoder.decode(ModeType.self, from: getData())
    }
}

public protocol ApiProcessor {
    func willRequest<Parameters: Encodable>(target: ApiTarget, parameters: Parameters) -> (ApiTarget, Parameters)
    func willResponse(target: ApiTarget, data: Data, response: HTTPURLResponse) throws -> Response
}
