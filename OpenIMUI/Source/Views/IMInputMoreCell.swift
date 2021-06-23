//
//  IMInputMoreCell.swift
//  MessageKit
//
//  Created by Snow on 2021/6/7.
//

import UIKit

public struct IMInputMoreItem {
    let title: String
    let image: UIImage?
    
    public init(title: String, image: UIImage?) {
        self.title = title
        self.image = image
    }
}

open class IMInputMoreCell: UICollectionViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.11, green: 0.45, blue: 0.93, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 7),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor),
        ])
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor),
        ])
        return imageView
    }()
    
    var item: IMInputMoreItem! {
        didSet {
            imageView.image = item.image
            titleLabel.text = item.title
        }
    }
}
