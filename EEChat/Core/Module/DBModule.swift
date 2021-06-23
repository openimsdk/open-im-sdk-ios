//
//  DBModule.swift
//  EEChat
//
//  Created by Snow on 2021/3/29.
//

import Foundation
import GRDB

public class DBModule {
    private struct KeyValue: Codable, FetchableRecord, PersistableRecord {
        public var key: String
        public var value: Data
    }
    
    public static let shared = DBModule()
    private init() {}
    
    lazy var dbQueue: DatabaseQueue = {
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        
        let dbQueue = try! DatabaseQueue(path: path + "/database.sqlite")        
        try! dbQueue.write({ (db) -> Void in
            try? db.create(table: KeyValue.databaseTableName, ifNotExists: true, body: { (t) in
                t.column("key", .text).primaryKey()
                t.column("value", .blob)
            })
        })
        return dbQueue
    }()
    
    public func set<ValueType: Encodable>(key: String, value: ValueType) {
        dbQueue.asyncWriteWithoutTransaction { (db) in
            let data: Data = {
                // fixbug: iOS12 JSONEncoder().encode 字符串会崩溃
                if let str = value as? String {
                    return str.data(using: .utf8)!
                }
                return try! JSONEncoder().encode(value)
            }()
            let model = KeyValue(key: key, value: data)
            try! model.save(db)
        }
    }
    
    public func get<ValueType: Decodable>(key: String) -> ValueType? {
        return try! dbQueue.read { (db) -> ValueType? in
            if let result = try! KeyValue.fetchOne(db, key: key) {
                if ValueType.self == String.self {
                    return (String(data: result.value, encoding: .utf8)! as! ValueType)
                }
                return try? JSONDecoder().decode(ValueType.self, from: result.value)
            }
            return nil
        }
    }
}

