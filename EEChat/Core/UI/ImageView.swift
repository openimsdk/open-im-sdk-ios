//
//  ImageView.swift
//  EEChat
//
//  Created by Snow on 2021/5/18.
//

import UIKit
import Kingfisher

class ImageView: AnimatedImageView {
    
    func setImage(with string: String?, placeholder: UIImage? = nil) {
        setImage(with: URL(string: string ?? ""), placeholder: placeholder)
    }

    func setImage(with url: URL?, placeholder: UIImage? = nil) {
        kf.setImage(with: url, placeholder: placeholder)
    }

}
