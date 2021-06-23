//
//  ImageCache.swift
//  MessageKit
//
//  Created by Snow on 2021/5/12.
//

import UIKit

public final class ImageCache {
    internal static let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "cn.rentsoft.ImageCache"
        return cache
    }()
    
    public static func named(_ named: String, withCapInsets capInsets: UIEdgeInsets = .zero, resizingMode: UIImage.ResizingMode = .stretch) -> UIImage? {
        let key = "\(named) \(capInsets) \(resizingMode.rawValue)" as NSString
        if let image = cache.object(forKey: key) {
            return image
        }
        
        let image: UIImage? = {
            if let image = UIImage(named: named) {
                return image
            }
            
            let bundle = Bundle(for: ImageCache.self)
            if let image = UIImage(named: named, in: bundle, compatibleWith: nil) {
                return image
            }
            
            if var resourceURL = bundle.resourceURL {
                resourceURL.appendPathComponent("OpenIMUI.bundle")
                if let image = UIImage(named: named, in: Bundle(url: resourceURL), compatibleWith: nil) {
                    return image
                }
            }
            
            return nil
        }()
        
        guard var image = image else {
            Logger.error("\"\(named)\" not exists", type: Self.self)
            return nil
        }
        
        if capInsets != .zero {
            image = image.resizableImage(withCapInsets: capInsets, resizingMode: resizingMode)
        }
        
        cache.setObject(image, forKey: key)
        return image
    }
}
