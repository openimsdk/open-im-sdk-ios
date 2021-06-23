//
//  ImageView.swift
//  EEChat
//
//  Created by Snow on 2021/5/18.
//

import UIKit
import Kingfisher

class ImageView: AnimatedImageView {

    func setImage(with url: URL?, placeholder: UIImage? = nil) {
        kf.setImage(with: url, placeholder: placeholder)
    }

}
