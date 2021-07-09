//
//  FriendSettingVC.swift
//  EEChat
//
//  Created by Snow on 2021/5/25.
//

import UIKit
import OpenIM
import OpenIMUI

class FriendSettingVC: BaseViewController {

    @IBOutlet var avatarImageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var topButton: UIButton!
    @IBOutlet var blacklistButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUI()
        
        OUIKit.shared.getUser(model.userID, isForce: true, callback: { user in
            self.set(user: user)
        })
    }
    
    private lazy var model: OIMConversation = {
        assert(param is OIMConversation)
        return param as! OIMConversation
    }()
    
    private func refreshUI() {
        avatarImageView.setImage(with: URL(string: model.faceUrl),
                                 placeholder: UIImage(named: "icon_default_avatar"))
        nameLabel.text = model.showName
        topButton.isSelected = model.isPinned
    }
    
    private func set(user: OIMUser?) {
        guard let user = user else { return }
        blacklistButton.isSelected = user.isInBlackList
    }
    
    // MARK: - Action
    
    @IBAction func historyAction() {
//        ChatHistoryVC.show(param: SessionType.p2p(model.userInfo.uid))
    }
    
    @IBAction func remarkAction() {
        UIAlertController.show(title: LocalizedString("Modify the remark"),
                               message: nil,
                               text: model.showName,
                               placeholder: LocalizedString("Please enter remarks"))
        { (text) in
            let model = self.model
            
            rxRequest(showLoading: true, action: { OIMManager.setFriendInfo(model.userID, comment: text, callback: $0) })
                .subscribe(onSuccess: { _ in
                    MessageModule.showMessage(LocalizedString("Modify the success"))
                    self.model.showName = text
                    self.refreshUI()
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    @IBAction func topAction(_ sender: UIButton) {
        let isPinned = !model.isPinned
        
        OIMManager.pinConversation(model.conversationID, isPinned: isPinned) { [weak self] result in
            if case .success = result {
                guard let self = self else { return }
                self.model.isPinned = isPinned
                self.refreshUI()
            }
        }
    }
    
    @IBAction func blacklistAction(_ sender: UIButton) {
        let uid = model.userID
        let isInBlackList = blacklistButton.isSelected
        let observe = isInBlackList
            ? rxRequest(showLoading: true, action: { OIMManager.deleteFromBlackList(uid: uid, callback: $0) })
            : rxRequest(showLoading: true, action: { OIMManager.addToBlackList(uid: uid, callback: $0) })
        
        observe
            .subscribe(onSuccess: { _ in
                sender.isSelected = !isInBlackList
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
                OIMManager.deleteConversation(self.model.conversationID) { result in
                    if case .success = result {
                        NavigationModule.shared.pop(popCount: 2)
                    }
                }
            }
        }
    }
    
    @IBAction func reportAction() {
        ReportVC.show(param: model)
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
        let uid = model.userID
        rxRequest(showLoading: true, action: { OIMManager.deleteFromFriendList(uid, callback: $0) })
            .subscribe(onSuccess: { _ in
                NavigationModule.shared.pop(popCount: 2)
            })
            .disposed(by: disposeBag)
    }
}
