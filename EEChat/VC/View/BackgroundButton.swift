//
//  BackgroundButton.swift
//  EEChat
//
//  Created by Snow on 2021/5/25.
//

import UIKit

class BackgroundButton: UIButton {
    
    @IBInspectable public var normalBackgroundColor: UIColor?
    @IBInspectable public var highlightedBackgroundColor: UIColor? = UIColor.eec.rgb(0xE8F2FF)

    override func awakeFromNib() {
        super.awakeFromNib()
        if let color = normalBackgroundColor {
            let highlightedImage = UIImage.eec.image(color: color)
            self.setBackgroundImage(highlightedImage, for: .normal)
        }
        if let color = highlightedBackgroundColor {
            let highlightedImage = UIImage.eec.image(color: color)
            self.setBackgroundImage(highlightedImage, for: .highlighted)
        }
    }

}
