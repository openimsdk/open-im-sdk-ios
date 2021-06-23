//
//  WeakBox.swift
//  EEChat
//
//  Created by Snow on 2021/4/15.
//

import Foundation

final class WeakBox<Value: AnyObject> {
    weak var unbox: Value?
    init(_ value: Value?) {
        unbox = value
    }
}

extension WeakBox: Equatable where Value: Equatable {
    static func == (lhs: WeakBox, rhs: WeakBox) -> Bool {
        return lhs.unbox == rhs.unbox
    }
}

extension WeakBox: Hashable where Value: Hashable {
    func hash(into hasher: inout Hasher) {
        unbox?.hash(into: &hasher)
    }
}

extension Array where Element: WeakBox<AnyObject> {
    static func from<T: AnyObject>(value: [T?]) -> [WeakBox<T>] {
        return value.map { WeakBox<T>($0) }
    }
}

extension Set where Element: WeakBox<AnyObject> {
    static func from<T: Hashable>(value: [T?]) -> Set<WeakBox<T>> {
        return value.reduce(into: Set<WeakBox<T>>()) { (result, value) in
            result.insert(WeakBox(value))
        }
    }
}
