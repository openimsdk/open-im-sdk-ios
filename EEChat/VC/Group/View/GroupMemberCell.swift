//
//  GroupMemberCell.swift
//  EEChat
//
//  Created by Snow on 2021/7/6.
//

import UIKit
import OpenIM

class GroupMemberCell: UICollectionViewCell {
    
    lazy var avatarImageView: ImageView = {
        let imageView = ImageView()
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.eec_rgb(0x999999)
        label.font = UIFont.systemFont(ofSize: 12)
        addSubview(label)
        avatarImageView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.width)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview()
        }
        return label
    }()
    
    var model: Any! {
        didSet {
            avatarImageView.eec_setRadius = bounds.width / 2
            switch model {
            case let model as OIMUser:
                avatarImageView.setImage(with: model.icon,
                                         placeholder: UIImage(named: "icon_default_avatar"))
            case let model as OIMGroupMember:
                nameLabel.text = model.getName()
                avatarImageView.setImage(with: model.faceUrl,
                                         placeholder: UIImage(named: "icon_default_avatar"))
            case let image as UIImage:
                nameLabel.text = ""
                avatarImageView.image = image
            default:
                fatalError()
            }
        }
    }
    
}
