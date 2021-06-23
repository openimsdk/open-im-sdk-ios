//
//  Extension.swift
//  OpenIM
//
//  Created by Snow on 2021/6/10.
//

import Foundation

extension Encodable {
    func toData() -> Data {
        return try! JSONEncoder().encode(self)
    }
    
    func toString() -> String {
        let data = try! JSONEncoder().encode(self)
        return String(data: data, encoding: .utf8)!
    }
}


