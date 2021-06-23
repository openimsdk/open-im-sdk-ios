//
//  InsetLabel.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit

open class InsetLabel: UILabel {

    open var textInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }

    open override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }

}
