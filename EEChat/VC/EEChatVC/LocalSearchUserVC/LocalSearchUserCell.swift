//
//  LocalSearchUserCell.swift
//  EEChat
//
//  Created by Snow on 2021/4/23.
//

import UIKit
import OpenIM
import OpenIMUI

class LocalSearchUserCell: UITableViewCell {

    @IBOutlet var avatarView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var model: Any! {
        didSet {
            func config(user: OIMUser?) {
                if let user = user {
                    nameLabel.text = user.getName()
                    avatarView.setImage(with: user.icon,
                                        placeholder: UIImage(named: "icon_default_avatar"))
                }
            }
            switch model {
            case let model as OIMUser:
                config(user: model)
            case let model as OIMConversation:
                if model.userID != "" {
                    let user = OUIKit.shared.getUser(model.userID) { user in
                        config(user: user)
                    }
                    config(user: user)
                }
            default:
                break
            }
        }
    }
    
}
