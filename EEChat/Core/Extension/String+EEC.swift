//
//  String+EEC.swift
//  EEChat
//
//  Created by Snow on 2021/3/30.
//

import Foundation

extension String {
    public func eec_pinyin() -> String {
        let text = NSMutableString(string: self)
        CFStringTransform(text, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(text, nil, kCFStringTransformStripDiacritics, false)
        let pinyin = text.capitalized
        return pinyin
    }
}
