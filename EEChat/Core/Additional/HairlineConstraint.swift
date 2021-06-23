//
//  HairlineConstraint.swift
//  EEChat
//
//  Created by Snow on 2021/4/8.
//

import UIKit

public class HairlineConstraint: NSLayoutConstraint {
    public override func awakeFromNib() {
        super.awakeFromNib()

        constant = 1.0 / UIScreen.main.scale
        if let view = firstItem as? UIView {
            view.isUserInteractionEnabled = false
        }
    }
}
