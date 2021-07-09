//
//  NewFriendCell.swift
//  EEChat
//
//  Created by Snow on 2021/4/21.
//

import UIKit
import OpenIM

class NewFriendCell: UITableViewCell {

    @IBOutlet var avatarImageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addBtn: UIButton!
    
    var model: OIMFriendApplicationModel! {
        didSet {
            refresh()
        }
    }
    
    private func refresh() {
        let userInfo = model.info
        avatarImageView.setImage(with: userInfo.icon,
                                 placeholder: UIImage(named: "icon_default_avatar"))
        
        nameLabel.text = userInfo.getName()
        switch model.flag {
        case .`default`:
            addBtn.isUserInteractionEnabled = true
            addBtn.backgroundColor = UIColor.eec.rgb(0x1B72EC)
            addBtn.setTitleColor(.white, for: .normal)
            addBtn.setTitle(LocalizedString("Add"), for: .normal)
        case .agree:
            fallthrough
        case .reject:
            addBtn.isUserInteractionEnabled = false
            addBtn.backgroundColor = .clear
            addBtn.setTitleColor(UIColor.eec.rgb(0x666666), for: .normal)
            if model.flag == .agree {
                addBtn.setTitle(LocalizedString("Agreed"), for: .normal)
            } else {
                addBtn.setTitle(LocalizedString("Rejected"), for: .normal)
            }
        }
    }
    
    @IBAction func addAction() {
        let uid = model.info.uid
        _ = rxRequest(showLoading: true, action: { OIMManager.acceptFriendApplication(uid: uid, callback: $0) })
            .subscribe(onSuccess: { _ in
                self.model.flag = .agree
                self.refresh()
            })
    }
    
}
