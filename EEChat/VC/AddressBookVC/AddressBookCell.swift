//
//  AddressBookCell.swift
//  EEChat
//
//  Created by Snow on 2021/4/9.
//

import UIKit
import Kingfisher
import OpenIM

class AddressBookCell: UITableViewCell {

    @IBOutlet var avatarImageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var model: OIMUserInfo! {
        didSet {
            nameLabel.text = model.getName()
            avatarImageView.setImage(with: model.icon,
                                     placeholder: UIImage(named: "icon_default_avatar"))
        }
    }
}
