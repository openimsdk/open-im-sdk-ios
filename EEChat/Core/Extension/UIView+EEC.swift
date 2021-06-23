//
//  UIView+EEC.swift
//  EEChat
//
//  Created by Snow on 2021/4/8.
//

import UIKit

public extension Namespace where Base: UIView {
    static func nib(_ nibName: String? = nil, bundle: Bundle? = nil) -> UINib {
        let nibName = nibName ?? String(describing: Base.self)
        return UINib(nibName: nibName, bundle: bundle)
    }
}

extension UIView {
    @IBInspectable public var eec_setRadius: CGFloat {
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
        get {
            fatalError()
        }
    }

    @IBInspectable public var eec_setBorderColor: UIColor {
        set {
            layer.borderWidth = 1 / UIScreen.main.scale
            layer.borderColor = newValue.cgColor
        }
        get {
            fatalError()
        }
    }
}
