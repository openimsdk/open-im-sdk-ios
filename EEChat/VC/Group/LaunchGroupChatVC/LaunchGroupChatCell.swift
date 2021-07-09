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
    
    var model: Any! {
        didSet {
            switch model {
            case let model as OIMUser:
                avatarImageView.setImage(with: model.icon,
                                         placeholder: UIImage(named: "icon_default_avatar"))
                nameLabel.text = model.getName()
            case let model as OIMGroupMember:
                avatarImageView.setImage(with: model.faceUrl,
                                         placeholder: UIImage(named: "icon_default_avatar"))
                nameLabel.text = model.getName()
            default:
                fatalError()
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        customMultipleChioce()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        selectImageView = nil
        customMultipleChioce()
    }
    
    private var selectImageView: UIImageView?
    
    private func customMultipleChioce() {
        if selectImageView == nil {
            guard let cls = NSClassFromString("UITableViewCellEditControl") else {
                return
            }
            for control in self.subviews {
                if control.isMember(of: cls) {
                    for view in control.subviews {
                        if let imageView = view as? UIImageView {
                            selectImageView = imageView
                        }
                    }
                }
            }
        }
        
        if let imageView = selectImageView {
            imageView.image = {
                if self.isSelected {
                    return UIImage(named: "launch_group_chat_icon_selected")
                } else {
                    return UIImage(named: "launch_group_chat_icon_unselected")
                }
            }()
        }
    }
    
}
