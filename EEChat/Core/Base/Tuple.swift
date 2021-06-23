//
//  Tuple.swift
//  EEChat
//
//  Created by Snow on 2021/4/21.
//

import Foundation


struct Tuple<Type0, Type1> {
    let value0: Type0
    let value1: Type1
}

extension Tuple: Equatable where Type0: Equatable, Type1: Equatable {
    
}

extension Tuple: Hashable where Type0: Hashable, Type1: Hashable {
    
}
