//
//  UIImage+EEC.swift
//  EEChat
//
//  Created by Snow on 2021/4/25.
//

import UIKit

public extension Namespace where Base: UIImage {
    
    static func image(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    static func image(rgb: UInt32, alpha: CGFloat = 1) -> UIImage {
        let color = UIColor.eec.rgb(rgb, alpha: alpha)
        return image(color: color)
    }
    
}
