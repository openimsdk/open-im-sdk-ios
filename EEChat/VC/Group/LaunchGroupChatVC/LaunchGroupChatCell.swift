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
    
    override func layoutSubviews() {
        customMultipleChioce()
        super.layoutSubviews()
    }
    
    private var selectImageView: UIImageView?
    
    private func customMultipleChioce() {
        if selectImageView == nil {
            guard isEditing, let cls = NSClassFromString("UITableViewCellEditControl") else {
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
            if self.isSelected {
                imageView.image = UIImage(named: "launch_group_chat_icon_selected")
            } else {
                imageView.image = UIImage(named: "launch_group_chat_icon_unselected")
            }
        }
    }
    
}
