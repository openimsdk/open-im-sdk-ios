//
//  GroupSettingVC.swift
//  EEChat
//
//  Created by Snow on 2021/7/7.
//

import UIKit
import OpenIM
import RxSwift

class GroupSettingVC: BaseViewController {
    
    override class func show(param: Any? = nil, callback: BaseViewController.Callback? = nil) {
        assert(param is OIMConversation)
        let conversation = param as! OIMConversation
        var members: [OIMGroupMember] = []
        _ = rxRequest(showLoading: true, callback: { OIMManager.getGroupMemberList(gid: conversation.groupID,
                                                                                   filter: .all,
                                                                                   next: 0,
                                                                                   callback: $0) })
            .do(onSuccess: { memberResult in
                members = memberResult.data
            })
            .flatMap({ _ -> Single<[OIMGroupInfo]> in
                return rxRequest(showLoading: true,
                                 callback: { OIMManager.getGroupsInfo(gids: [conversation.groupID], callback: $0) })
            })
            .subscribe(onSuccess: { array in
                if let groupInfo = array.first {
                    super.show(param: (conversation, groupInfo, members), callback: callback)
                }
            })
    }
    
    private var conversation: OIMConversation!
    private var groupInfo: OIMGroupInfo!
    private var members: [OIMGroupMember] = []

    @IBOutlet var avatarImageView: ImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    @IBOutlet var memberView: GroupMemberView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(param is (OIMConversation, OIMGroupInfo, [OIMGroupMember]))
        let (conversation, groupInfo, members) = param as! (OIMConversation, OIMGroupInfo, [OIMGroupMember])
        self.conversation = conversation
        self.groupInfo = groupInfo
        self.members = members
        
        memberView.layout.itemSize = CGSize(width: 34, height: 54)
        memberView.members = members
        
        memberView.addBlock = {
            
        }
        
        memberView.removeBlock = {
            
        }
        
        bindAction()
        refreshUI()
    }
    
    private func bindAction() {
        
    }
    
    private func refreshUI() {
        avatarImageView.setImage(with: groupInfo.faceUrl,
                                 placeholder: UIImage(named: "icon_default_avatar"))
        nameLabel.text = groupInfo.groupName
        detailLabel.text = groupInfo.introduction
        
        pinBtn.isSelected = conversation.isPinned
    }

    @IBAction func memberListAction() {
        GroupMemberVC.show(param: groupInfo.groupID) { [weak self] any in
            let members = any as! [OIMGroupMember]
            self?.members = members
        }
    }
    
    @IBAction func transferAction() {
        let groupID = self.conversation.groupID
        let uid = OIMManager.getLoginUser()
        rxRequest(showLoading: true, callback: { OIMManager.getGroupMembersInfo(gid: groupID,
                                                                                uids: [uid],
                                                                                callback: $0) })
            .flatMap({ members -> Single<Void> in
                if let member = members.first, member.role == .owner {
                    return .just(Void())
                }
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "You're not an administrator."])
            })
            .subscribe(onSuccess: { _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func changeNicknameAction() {
        
    }
    
    @IBOutlet var muteBtn: SwitchButton!
    @IBAction func muteNotificationAction(_ sender: UIButton) {
        
    }
    
    @IBOutlet var pinBtn: SwitchButton!
    @IBAction func topAction(_ sender: UIButton) {
        let isPinned = !sender.isSelected
        OIMManager.pinConversation(conversation.conversationID, isPinned: isPinned) { result in
            sender.isSelected = isPinned
        }
    }
    
    @IBAction func leaveAction() {
        let groupID = groupInfo.groupID
        rxRequest(showLoading: true, callback: { OIMManager.quitGroup(gid: groupID, callback: $0) })
            .subscribe(onSuccess: {
                NavigationModule.shared.pop(popCount: 2)
            })
            .disposed(by: self.disposeBag)
    }
}
