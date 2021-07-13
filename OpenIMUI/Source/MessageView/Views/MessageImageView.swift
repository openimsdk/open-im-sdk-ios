//
//  MessageImageView.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit
import Kingfisher

open class MessageImageView: AnimatedImageView {
    
    open func setImage(with string: String?, placeholder: UIImage? = nil) {
        kf.setImage(with: URL(string: string ?? ""), placeholder: placeholder)
    }
    
    open func setImage(with url: URL?, placeholder: UIImage? = nil) {
        kf.setImage(with: url, placeholder: placeholder)
    }
    
    open func setImage(with url: URL?,
                       progressBlock: @escaping (Int) -> Void,
                       completionHandler: @escaping (UIImage?) -> Void) {
        kf.setImage(with: url,
                    options: [.backgroundDecode, .loadDiskFileSynchronously],
                    progressBlock: { receivedSize, totalSize in
                        let percent = Float(receivedSize) / Float(totalSize) * 100
                        progressBlock(Int(floor(percent)))
                    },
                    completionHandler: { result in
                        switch result {
                        case .success(let data):
                            completionHandler(data.image)
                        case .failure(_):
                            completionHandler(nil)
                        }
                    })
    }
}
