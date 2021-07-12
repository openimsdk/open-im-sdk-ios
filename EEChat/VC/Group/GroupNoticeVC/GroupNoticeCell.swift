//
//  GroupNoticeCell.swift
//  EEChat
//
//  Created by Snow on 2021/7/9.
//

import UIKit
import OpenIM

class GroupNoticeCell: UITableViewCell {

    @IBOutlet var avatarImageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var msgLabel: UILabel!

    @IBOutlet var tipsLabel: UILabel!
    
    var model: OIMGroupApplication! {
        didSet {
            refreshUI()
        }
    }
    
    private func refreshUI() {
        avatarImageView.setImage(with: model.fromUserFaceURL,
                                 placeholder: UIImage(named: "icon_default_avatar"))
        nameLabel.text = model.fromUserNickName
        msgLabel.text = model.reqMsg
        tipsLabel.superview?.isHidden = model.flag == .none
        switch model.flag {
        case .none:
            break
        case .agree:
            tipsLabel.text = "Agreed"
        case .refuse:
            tipsLabel.text = "Refused"
        }
    }
    
    @IBAction func agreeAction() {
        _ = rxRequest(showLoading: true, action: { OIMManager.acceptGroupApplication(self.model,
                                                                                     reason: "",
                                                                                     callback: $0) })
            .subscribe(onSuccess: {
                self.model.flag = .agree
                self.refreshUI()
            })
    }
    
    @IBAction func refuseAction() {
        _ = rxRequest(showLoading: true, action: { OIMManager.refuseGroupApplication(self.model,
                                                                                     reason: "",
                                                                                     callback: $0) })
            .subscribe(onSuccess: {
                self.model.flag = .refuse
                self.refreshUI()
            })
    }

}
