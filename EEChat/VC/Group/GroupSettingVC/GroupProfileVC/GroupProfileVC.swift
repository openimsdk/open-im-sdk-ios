//
//  GroupProfileVC.swift
//  EEChat
//
//  Created by Snow on 2021/7/8.
//

import UIKit
import RxSwift
import OpenIM

class GroupProfileVC: BaseViewController {
    
    var member: OIMGroupMember!
    var groupInfo: OIMGroupInfo!

    @IBOutlet var avatarImageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    
    @IBOutlet var textView: QMUITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        refreshUI()
    }
    
    private func bindAction() {
        assert(param is (OIMGroupMember, OIMGroupInfo))
        (member, groupInfo) = param as! (OIMGroupMember, OIMGroupInfo)
        textView.isEditable = false
        textView.eec.autoHeight(minHeight: 200)
            .disposed(by: disposeBag)
        textView.returnKeyType = .done
        textView.delegate = self
        
        if member.role == .none {
            modifyBtn.eec_collapsed = true
        }
    }
    
    private func refreshUI(needCallback: Bool = false) {
        avatarImageView.setImage(with: groupInfo.faceUrl,
                                 placeholder: UIImage(named: "icon_default_avatar"))
        nameLabel.text = groupInfo.groupName
        idLabel.text = "Group number：" + groupInfo.groupID
        textView.text = groupInfo.introduction
        if needCallback {
            callback?(groupInfo!)
        }
    }
    
    @IBAction func copyIDAction() {
        UIPasteboard.general.string = groupInfo.groupID
        MessageModule.showMessage(LocalizedString("The group number has been copied!"))
    }
    
    @IBOutlet var modifyBtn: UIButton!
    @IBAction func modifyAction() {
        UIAlertController.show(title: "Modify group data",
                               message: nil,
                               buttons: [
                                "Group chat name",
                                "Group portrait",
                                "Group Introduction",
                               ],
                               cancel: "cancel")
        { [unowned self] index in
            switch index {
            case 1:
                modifyGroupName()
            case 2:
                modifyAvatar()
            case 3:
                textView.isEditable = true
                textView.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    func modifyAvatar() {
        PhotoModule.shared.showPicker(type: .image,
                                      allowTake: true,
                                      allowCrop: true,
                                      cropSize: CGSize(width: 100, height: 100))
        { image, _ in
            var icon = ""
            QCloudModule.shared.upload(prefix: "chat/group/avatar", files: [image])
                .flatMap { [unowned self] (paths) -> Single<Void> in
                    icon = paths[0]
                    let param = OIMGroupInfoParam(groupInfo: groupInfo,
                                                  faceUrl: icon)
                    return rxRequest(showLoading: true, action: { OIMManager.setGroupInfo(param, callback: $0) })
                }
                .subscribe(onSuccess: { resp in
                    MessageModule.showMessage(LocalizedString("Modify the success"))
                    self.groupInfo.faceUrl = icon
                    self.refreshUI(needCallback: true)
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    func modifyGroupName() {
        let groupInfo = self.groupInfo!
        UIAlertController.show(title: "Change the group name?",
                               message: nil,
                               text: groupInfo.groupName,
                               placeholder: "") { text in
            let param = OIMGroupInfoParam(groupInfo: groupInfo,
                                          groupName: text)
            rxRequest(showLoading: true, action: { OIMManager.setGroupInfo(param, callback: $0) })
                .subscribe(onSuccess: {
                    MessageModule.showMessage("Group name modification successful.")
                    self.groupInfo.groupName = text
                    self.refreshUI(needCallback: true)
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    func modifyIntroduction() {
        view.endEditing(true)
        let introduction = textView.text!
        let param = OIMGroupInfoParam(groupInfo: groupInfo,
                                      introduction: introduction)
        rxRequest(showLoading: true, action: { OIMManager.setGroupInfo(param, callback: $0) })
            .subscribe(onSuccess: { [unowned self] in
                MessageModule.showMessage("Modify the introduction successfully.")
                self.textView.isEditable = false
                self.groupInfo.introduction = introduction
                self.refreshUI(needCallback: true)
            })
            .disposed(by: self.disposeBag)
    }
}

extension GroupProfileVC: QMUITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            modifyIntroduction()
            return false
        }
        return true
    }
}
