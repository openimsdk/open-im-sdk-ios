//
//  IMTextView.swift
//  MessageKit
//
//  Created by Snow on 2021/5/21.
//

import UIKit

open class IMTextView: UITextView {
    
    public weak var overrideNextResponder: UIResponder?
    
    open override var next: UIResponder? {
        return overrideNextResponder ?? super.next
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if overrideNextResponder != nil {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    public var maxHeight: CGFloat = 67
    
    func heightThatFits(_ width: CGFloat? = nil) -> CGFloat {
        let height = sizeThatFits(CGSize(width: width ?? bounds.width, height: maxHeight)).height
        return min(height, maxHeight)
    }
    
}
