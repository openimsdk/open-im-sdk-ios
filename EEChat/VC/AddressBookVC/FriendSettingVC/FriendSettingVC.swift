//
//  FriendSettingVC.swift
//  EEChat
//
//  Created by Snow on 2021/5/25.
//

import UIKit
import OpenIM

class FriendSettingVC: BaseViewController {
    
    override class func show(param: Any? = nil, callback: BaseViewController.Callback? = nil) {
        assert(param is String)
        let uid = param as! String
        
        _ = rxRequest(showLoading: true, callback: { OIMManager.getUsers(uids: [uid], callback: $0) })
            .subscribe(onSuccess: { array in
                if let model = array.first {
                    super.show(param: model, callback: callback)
                }
            })
    }

    @IBOutlet var avatarImageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var topButton: UIButton!
    @IBOutlet var blacklistButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUI()
    }
    
    private lazy var model: OIMUserInfo = {
        assert(param is OIMUserInfo)
        return param as! OIMUserInfo
    }()
    
    private func refreshUI() {
        avatarImageView.setImage(with: model.icon,
                                 placeholder: UIImage(named: "icon_default_avatar"))
        nameLabel.text = model.getName()
        blacklistButton.isSelected = model.isInBlackList
        
//        if let session = OIMManager.shared.getSession(.p2p(model.uid)) {
//            topButton.isSelected = session.isTop
//        } else {
//            topButton.isSelected = false
//        }
    }
    
    // MARK: - Action
    
    @IBAction func historyAction() {
//        ChatHistoryVC.show(param: SessionType.p2p(model.userInfo.uid))
    }
    
    @IBAction func remarkAction() {
        UIAlertController.show(title: LocalizedString("Modify the remark"),
                               message: nil,
                               text: model.comment,
                               placeholder: LocalizedString("Please enter remarks"))
        { (text) in
            let model = self.model
            
            rxRequest(showLoading: true, callback: { OIMManager.setFriendInfo(model.uid, comment: text, callback: $0) })
                .subscribe(onSuccess: { _ in
                    MessageModule.showMessage(text: LocalizedString("Modify the success"))
                    self.model.comment = text
                    self.refreshUI()
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    @IBAction func topAction(_ sender: UIButton) {
//        let userInfo = model.userInfo
//        let isTop = !sender.isSelected
//        if let session = OIMManager.shared.getSession(.p2p(userInfo.uid)) {
//            session.isTop = isTop
//        } else {
//            let session = Session()
//            session.session = .p2p(userInfo.uid)
//            session.isTop = true
//            session.date = Date().timeIntervalSince1970
//            OIMManager.shared.update(session: session)
//        }
//        sender.isSelected = isTop
    }
    
    @IBAction func blacklistAction(_ sender: UIButton) {
        let uid = model.uid
        let isInBlackList = model.isInBlackList
        let observe = isInBlackList
            ? rxRequest(showLoading: true, callback: { OIMManager.deleteFromBlackList(uid: uid, callback: $0) })
            : rxRequest(showLoading: true, callback: { OIMManager.addToBlackList(uid: uid, callback: $0) })
        
        observe
            .subscribe(onSuccess: { [unowned self] _ in
                let text = isInBlackList ? LocalizedString("Remove blacklist successfully") : LocalizedString("Add blacklist successfully")
                MessageModule.showMessage(text: text)
                self.model.isInBlackList = !isInBlackList
                self.refreshUI()
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func clearHistoryAction() {
        UIAlertController.show(title: LocalizedString("Clear the chat history?"),
                               message: nil,
                               buttons: [LocalizedString("Yes")],
                               cancel: LocalizedString("No"))
        { (index) in
            if index == 1 {
//                let uid = self.model.userInfo.uid
//                OIMManager.shared.deleteAllMessage(.p2p(uid))
            }
        }
    }
    
    @IBAction func delFriendAction() {
        UIAlertController.show(title: LocalizedString("Remove friends?"),
                               message: nil,
                               buttons: [LocalizedString("Yes")],
                               cancel: LocalizedString("No"))
        { (index) in
            if index == 1 {
                self.delFriend()
            }
        }
    }
    
    private func delFriend() {
        let uid = model.uid
        rxRequest(showLoading: true, callback: { OIMManager.deleteFromFriendList(uid, callback: $0) })
            .subscribe(onSuccess: { _ in
                NavigationModule.shared.pop(popCount: 2)
            })
            .disposed(by: disposeBag)
    }
}
