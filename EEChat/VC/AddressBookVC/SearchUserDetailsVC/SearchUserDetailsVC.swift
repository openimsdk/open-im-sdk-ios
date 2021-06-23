//
//  SearchUserDetailsVC.swift
//  EEChat
//
//  Created by Snow on 2021/5/19.
//

import UIKit
import OpenIM
import OpenIMUI

class SearchUserDetailsVC: BaseViewController {
    
    override class func show(param: Any? = nil, callback: BaseViewController.Callback? = nil) {
        switch param {
        case let uid as String:
            _ = rxRequest(showLoading: true, callback: { OIMManager.getUsers(uids: [uid], callback: $0) })
                .subscribe(onSuccess: { array in
                    super.show(param: array.first, callback: callback)
                })
        case is OIMUserInfo:
            super.show(param: param, callback: callback)
        default:
            fatalError()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        refreshUI()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onFriendApplicationListAcceptNotification(_:)),
                                               name: OUIKit.onFriendApplicationListAcceptNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var avatarImageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var accountLabel: UILabel!
    
    lazy var model: OIMUserInfo = {
        assert(param is OIMUserInfo)
        return param as! OIMUserInfo
    }()
    
    private func bindAction() {
        let layer = contentView.superview!.layer
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.14).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
        
        accountLabel.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { [unowned self] _ in
                UIPasteboard.general.string = self.model.uid
                MessageModule.showMessage(text: LocalizedString("The account has been copied!"))
            })
            .disposed(by: disposeBag)
    }
    
    private func refreshUI() {
        avatarImageView.setImage(with: model.icon,
                                 placeholder: UIImage(named: "icon_default_avatar"))
        nameLabel.text = model.getName()
        accountLabel.text = LocalizedString("Account:") + model.uid
        
        if model.uid == AccountManager.shared.model.userInfo.uid {
            button.eec_collapsed = true
            return
        }
        
        button.eec_collapsed = false
        if model.isFriend {
            button.setTitle(" " + LocalizedString("Chat"), for: .normal)
            button.setImage(UIImage(named: "friend_detail_icon_msg"), for: .normal)
        } else {
            button.setTitle(" " + LocalizedString("Add friend"), for: .normal)
            button.setImage(UIImage(named: "friend_detail_icon_add"), for: .normal)
        }
    }
    
    @IBOutlet var button: UIButton!
    @IBAction func btnAction() {
        if model.isFriend {
            EEChatVC.show(uid: model.uid, groupID: "")
            return
        }
        
        let param = OIMFriendAddApplication(uid: model.uid, reqMessage: "")
        rxRequest(showLoading: true, callback: { OIMManager.addFriend(param, callback: $0) })
            .subscribe(onSuccess: { _ in
                MessageModule.showMessage(text: LocalizedString("Sent friend request"))
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func onFriendApplicationListAcceptNotification(_ notification: Notification) {
        guard let uid = notification.object as? String else {
            return
        }
        if self.model.uid == uid {
            self.model.isFriend = true
            refreshUI()
        }
    }
}
