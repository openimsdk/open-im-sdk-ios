//
//  DispatchQueue+EEC.swift
//  EEChat
//
//  Created by snow on 2021/3/27.
//

import Foundation

public extension DispatchQueue {
    static func checkAsyncMain(execute work: @escaping @convention(block) () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}
