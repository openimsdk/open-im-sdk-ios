//
//  CodingKey.swift
//  EEChat
//
//  Created by Snow on 2021/5/11.
//

import Foundation

public struct LowercasedFirstLetterCodingKey: CodingKey {
    public var intValue: Int?
    public var stringValue: String
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
        
        guard let firstChar = stringValue.first else {
            return
        }
        
        let startIdx = self.stringValue.startIndex
        self.stringValue.replaceSubrange(startIdx...startIdx,
                                         with: String(firstChar).lowercased())
    }
    
    public init?(intValue: Int) {
        fatalError()
    }
}

public struct UppercasedFirstLetterCodingKey: CodingKey {
    public var intValue: Int?
    public var stringValue: String
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
        
        guard let firstChar = stringValue.first else {
            return
        }
        
        let startIdx = self.stringValue.startIndex
        self.stringValue.replaceSubrange(startIdx...startIdx,
                                         with: String(firstChar).uppercased())
    }
    
    public init?(intValue: Int) {
        fatalError()
    }
}

public struct AnyCodingKey: CodingKey {
    public static let empty = AnyCodingKey(string: "")
    
    public var intValue: Int?
    public var stringValue: String
    
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    public init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    init(string: String) {
        self.stringValue = string
        self.intValue = nil
    }
}

public extension JSONEncoder.KeyEncodingStrategy {
    static func convert<CodingKeyType: CodingKey>(type: CodingKeyType.Type) -> JSONEncoder.KeyEncodingStrategy {
        return .custom { codingKeys in
            guard let codingKey = codingKeys.last else {
                return AnyCodingKey.empty
            }
            
            if codingKey.intValue != nil {
                return codingKey
            }
        
            let key = codingKey.stringValue
            return type.init(stringValue: key) ?? codingKey
        }
    }
    
    static func convert(_ transform: @escaping (String) -> String?) -> JSONEncoder.KeyEncodingStrategy {
        return .custom { codingKeys in
            guard let codingKey = codingKeys.last else {
                return AnyCodingKey.empty
            }
            
            if codingKey.intValue != nil {
                return codingKey
            }
            
            let str = codingKey.stringValue
            if let newStr = transform(str) {
                return AnyCodingKey(string: newStr)
            }
            return codingKey
        }
    }
}

public extension JSONDecoder.KeyDecodingStrategy {
    static func convert<CodingKeyType: CodingKey>(type: CodingKeyType.Type) -> JSONDecoder.KeyDecodingStrategy {
        return .custom { codingKeys in
            guard let codingKey = codingKeys.last else {
                return AnyCodingKey.empty
            }
            
            if codingKey.intValue != nil {
                return codingKey
            }
            
            let key = codingKey.stringValue
            return type.init(stringValue: key) ?? codingKey
        }
    }
    
    static func convert(_ transform: @escaping (String) -> String?) -> JSONDecoder.KeyDecodingStrategy {
        return .custom { codingKeys in
            guard let codingKey = codingKeys.last else {
                return AnyCodingKey.empty
            }
            
            if codingKey.intValue != nil {
                return codingKey
            }
            
            let str = codingKey.stringValue
            if let newStr = transform(str) {
                return AnyCodingKey(string: newStr)
            }
            return codingKey
        }
    }
}

