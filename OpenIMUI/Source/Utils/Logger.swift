//
//  Logger.swift
//  MessageKit
//
//  Created by Snow on 2021/5/31.
//

import Foundation

public enum DebugMode: Int, CustomStringConvertible {
    case verbose = 1
    case debug = 2
    case info = 3
    case warn = 4
    case error = 5
    case none = 6
    
    public var description: String {
        switch self {
        case .verbose:
            return "◽️V"
        case .debug:
            return "◾️D"
        case .info:
            return "🔷I"
        case .warn:
            return "🔶W"
        case .error:
            return "❌E"
        case .none:
            fatalError()
        }
    }
}

public protocol LoggerSpec: AnyObject {
    var debugMode: DebugMode { get set }
    func log(_ debugMode: DebugMode, items: [Any], description: @autoclosure () -> String)
}

public extension LoggerSpec {
    
    func verbose(_ items: Any..., type: Any.Type, function: String = #function, line: Int = #line, column: Int = #column) {
        log(.verbose, items: items, description: "\(type).\(function) at line \(line)[\(column)]")
    }
    
    func debug(_ items: Any..., type: Any.Type, function: String = #function, line: Int = #line, column: Int = #column) {
        log(.debug, items: items, description: "\(type).\(function) at line \(line)[\(column)]")
    }
    
    func info(_ items: Any..., type: Any.Type, function: String = #function, line: Int = #line, column: Int = #column) {
        log(.info, items: items, description: "\(type).\(function) at line \(line)[\(column)]")
    }
    
    func warn(_ items: Any..., type: Any.Type, function: String = #function, line: Int = #line, column: Int = #column) {
        log(.warn, items: items, description: "\(type).\(function) at line \(line)[\(column)]")
    }
    
    func error(_ items: Any..., type: Any.Type, function: String = #function, line: Int = #line, column: Int = #column) {
        log(.error, items: items, description: "\(type).\(function) at line \(line)[\(column)]")
    }

}

private class DefaultLogger: LoggerSpec {
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        // "YYYY-MM-dd HH:mm:ss.SSS"
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    
    var debugMode: DebugMode = .error
    
    func log(_ debugMode: DebugMode, items: [Any], description: @autoclosure () -> String) {
        if self.debugMode.rawValue <= debugMode.rawValue {
            print(formatter.string(from: Date()), terminator: " ")
            print("[\(debugMode.description)]", terminator: " ")
            print(description(), terminator: " ")
            items.forEach { item in
                print(item, terminator: " ")
            }
            print()
        }
    }
}

public var Logger: LoggerSpec = DefaultLogger()
