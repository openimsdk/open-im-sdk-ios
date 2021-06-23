//
//  Api.swift
//  EEChat
//
//  Created by Snow on 2021/6/10.
//

import Foundation

public struct OperationID: Encodable {
    
    public init() {}
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let value = String(Int64(Date().timeIntervalSince1970))
        try container.encode(value)
    }
}

public struct OnlyOperationID: Encodable {
    let operationID = OperationID()
    
    public init() {}
}
