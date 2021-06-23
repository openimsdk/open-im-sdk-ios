//
//  UserCenterVC.swift
//  EEChat
//
//  Created by Snow on 2021/4/8.
//

import UIKit
import Kingfisher
import RxSwift
import OpenIM

class UserCenterVC: BaseViewController {

    @IBOutlet var avatarImageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var accountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        refresh()
    }
    
    private func bindAction() {
        
        accountLabel.rx.tapGesture()
            .when(.ended)
            .subscribe(onNext: { _ in
                UIPasteboard.general.string = AccountManager.shared.model.userInfo.uid
                MessageModule.showMessage(text: LocalizedString("The account has been copied!"))
            })
            .disposed(by: disposeBag)
    }
    
    private func refresh() {
        let userInfo = AccountManager.shared.model.userInfo
        avatarImageView.setImage(with: userInfo.icon,
                                 placeholder: UIImage(named: "icon_default_avatar"))
        nameLabel.text = userInfo.name
        accountLabel.text = LocalizedString("Account:") + userInfo.uid
    }
    
    // MARK: - Action
    
    @IBAction func changeAvatarAction() {
        PhotoModule.shared.showPicker(allowTake: true,
                                       allowCrop: true,
                                       cropSize: CGSize(width: 200, height: 200))
        { [unowned self] (image, asset) in
            var icon = ""
            QCloudModule.shared.upload(prefix: "chat/avatar", files: [image])
                .flatMap { (paths) -> Single<Void> in
                    icon = paths[0]
                    return rxRequest(showLoading: true) { OIMManager.setSelfInfo([.icon: icon], callback: $0) }
                }
                .subscribe(onSuccess: { resp in
                    AccountManager.shared.model.userInfo.icon = URL(string: icon)
                    MessageModule.showMessage(text: LocalizedString("Modify the success"))
                    self.refresh()
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    @IBAction func changeNickNameAction() {
        UIAlertController.show(title: LocalizedString("Modify the nickname"),
                               message: nil,
                               text: AccountManager.shared.model.userInfo.name,
                               placeholder: LocalizedString("Please enter a nickname"))
        { [unowned self] (text) in
            rxRequest(showLoading: true) { OIMManager.setSelfInfo([.name: text], callback: $0) }
                .subscribe(onSuccess: { _ in
                    AccountManager.shared.model.userInfo.name = text
                    MessageModule.showMessage(text: LocalizedString("Modify the success"))
                    self.refresh()
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    @IBAction func blacklistAction() {
        BlacklistVC.show()
    }

    @IBAction func logoutAction() {
        UIAlertController.show(title: LocalizedString("Are you sure to log out?"),
                               message: nil,
                               buttons: [LocalizedString("Yes")],
                               cancel: LocalizedString("No"))
        { (index) in
            if index == 1 {
                AccountManager.shared.logout()
            }
        }
    }
    
    @IBAction func notificationSettingAction() {
        NotificationSettingVC.show()
    }
}
