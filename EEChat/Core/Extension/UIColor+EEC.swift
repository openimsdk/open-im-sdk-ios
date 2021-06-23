//
//  UIColor+EEC.swift
//  EEChat
//
//  Created by Snow on 2021/4/1.
//

import UIKit

public extension Namespace where Base: UIColor {
    static func rgba(_ value: UInt32) -> UIColor {
        let alpha = CGFloat((value >> 0) & 0xFF) / 255
        return rgb((value >> 8) & 0xFFFFFF, alpha: alpha)
    }

    static func rgb(_ value: UInt32, alpha: CGFloat = 1) -> UIColor {
        let red = CGFloat((value >> 16) & 0xFF) / 255
        let green = CGFloat((value >> 8) & 0xFF) / 255
        let blue = CGFloat((value >> 0) & 0xFF) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

public extension UIColor {
    static func eec_rgba(_ value: UInt32) -> UIColor {
        return eec.rgba(value)
    }

    static func eec_rgb(_ value: UInt32, alpha: CGFloat = 1) -> UIColor {
        return eec.rgb(value, alpha: alpha)
    }
}
