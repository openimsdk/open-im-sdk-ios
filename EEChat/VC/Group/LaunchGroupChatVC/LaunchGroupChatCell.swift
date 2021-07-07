//
//  LaunchGroupChatCell.swift
//  EEChat
//
//  Created by Snow on 2021/7/5.
//

import UIKit
import OpenIM

class LaunchGroupChatCell: UITableViewCell {

    @IBOutlet var avatarImageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var model: OIMUserInfo! {
        didSet {
            avatarImageView.setImage(with: model.icon,
                                     placeholder: UIImage(named: "icon_default_avatar"))
            nameLabel.text = model.getName()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        customMultipleChioce()
    }
    
    override func layoutSubviews() {
        customMultipleChioce()
        super.layoutSubviews()
    }
    
    private func customMultipleChioce() {
        guard isEditing, let cls = NSClassFromString("UITableViewCellEditControl") else {
            return
        }
        for control in self.subviews {
            if control.isMember(of: cls) {
                for view in control.subviews {
                    if let imageView = view as? UIImageView {
                        if self.isSelected {
                            imageView.image = UIImage(named: "launch_group_chat_icon_selected")
                        } else {
                            imageView.image = UIImage(named: "launch_group_chat_icon_unselected")
                        }
                    }
                }
            }
        }
    }
    
}
