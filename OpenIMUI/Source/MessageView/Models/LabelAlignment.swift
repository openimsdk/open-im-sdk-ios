//
//  LabelAlignment.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit

public struct LabelAlignment: Equatable {

    public var textAlignment: NSTextAlignment
    public var textInsets: UIEdgeInsets
    
    public init(textAlignment: NSTextAlignment, textInsets: UIEdgeInsets) {
        self.textAlignment = textAlignment
        self.textInsets = textInsets
    }

}

public extension LabelAlignment {

    static func == (lhs: LabelAlignment, rhs: LabelAlignment) -> Bool {
        return lhs.textAlignment == rhs.textAlignment && lhs.textInsets == rhs.textInsets
    }

}
