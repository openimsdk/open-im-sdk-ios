//
//  BlacklistCell.swift
//  EEChat
//
//  Created by Snow on 2021/4/27.
//

import UIKit
import OpenIM

class BlacklistCell: UITableViewCell {

    @IBOutlet var avatarImageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var model: OIMUserInfo! {
        didSet {
            avatarImageView.setImage(with: model.icon,
                                     placeholder: UIImage(named: "icon_default_avatar"))
            nameLabel.text = model.getName()
        }
    }
    
    var removeCallback: (() -> Void)?
    @IBAction func removeAction() {
        removeCallback?()
    }
    
}
