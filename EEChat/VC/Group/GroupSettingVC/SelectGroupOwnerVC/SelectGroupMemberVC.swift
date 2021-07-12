//
//  SelectGroupMemberVC.swift
//  EEChat
//
//  Created by Snow on 2021/7/8.
//

import UIKit
import RxCocoa
import OpenIM

class SelectGroupMemberVC: BaseViewController {
    
    enum Operation {
        case transferOwner
        case removeMember
        case at
    }
    
    static func show(op: Operation, groupID: String, callback: BaseViewController.Callback? = nil) {
        _ = rxRequest(showLoading: true, action: { OIMManager.getGroupMemberList(gid: groupID,
                                                                                   filter: .all,
                                                                                   next: 0,
                                                                                   callback: $0) })
            .subscribe(onSuccess: { result in
                super.show(param: (op, result), callback: callback)
            })
    }

    @IBOutlet var tableView: UITableView!
    
    private var op: Operation!
    private var result: OIMManager.GroupMemberListResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(param is (Operation, OIMManager.GroupMemberListResult))
        (op, result) = param as! (Operation, OIMManager.GroupMemberListResult)
        
        bindAction()
        if op == .at {
            title = "Please select an at member"
        }
    }
    
    private lazy var relay = BehaviorRelay(value: result.data)
    
    private func bindAction() {
        tableView.register(LaunchGroupChatCell.eec.nib(), forCellReuseIdentifier: "cell")
        
        relay
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: LaunchGroupChatCell.self)) { _, element, cell in
                cell.model = element
            }
            .disposed(by: disposeBag)
        
        tableView.delegate = self
        tableView.rx.modelSelected(OIMGroupMember.self)
            .subscribe(onNext: { [unowned self] member in
                switch self.op! {
                case .transferOwner:
                    self.transferOwner(member: member)
                case .removeMember:
                    break
                case .at:
                    self.callback?(member)
                    NavigationModule.shared.pop()
                }
            })
            .disposed(by: disposeBag)
        
        if op == .removeMember {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "done",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(deleteMember))
            tableView.isEditing = true
            tableView.rx.modelDeselected(OIMGroupMember.self)
                .subscribe(onNext: { [unowned self] member in
                    
                })
                .disposed(by: disposeBag)
        }
    
    }
    
    private func transferOwner(member: OIMGroupMember) {
        let title = "Make sure to choose the new group leader of \(member.getName()), you will automatically give up the group leader identity."
        UIAlertController.show(title: title,
                               message: nil,
                               buttons: ["Yes"],
                               cancel: "No") { index in
            if index == 1 {
                _ = rxRequest(showLoading: true, action: { OIMManager.transferGroupOwner(gid: member.groupID,
                                                                                       uid: member.userId,
                                                                                       callback: $0) })
                    .subscribe(onSuccess: {
                        MessageModule.showMessage("You successfully transferred the owner of the group!")
                        NavigationModule.shared.pop()
                    })
            }
        }
    }
    
    @objc
    private func deleteMember() {
        guard let members: [OIMGroupMember] = tableView.indexPathsForSelectedRows?.map({ try! tableView.rx.model(at: $0) }),
              !members.isEmpty else {
            MessageModule.showMessage("Members to delete have not been selected.")
            return
        }
        
        let groupID = members[0].groupID
        let uids = members.map{ $0.userId }
        UIAlertController.show(title: "Are you sure you want to delete?",
                               message: nil,
                               buttons: ["Yes"],
                               cancel: "No")
        { [weak self] index in
            guard let self = self else { return }
            if index == 1 {
                rxRequest(showLoading: true, action: { OIMManager.kickGroupMember(gid: groupID,
                                                                                  reason: "",
                                                                                  uids: uids,
                                                                                  callback: $0) })
                    .subscribe(onSuccess: {
                        MessageModule.showMessage("Group member deleted successfully.")
                        NavigationModule.shared.pop()
                    })
                    .disposed(by: self.disposeBag)
            }
        }
    }
    
}

extension SelectGroupMemberVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let member: OIMGroupMember = try! tableView.rx.model(at: indexPath)
        switch op! {
        case .transferOwner:
            if member.role == .owner {
                MessageModule.showMessage("Can't transfer group to oneself.")
                return nil
            }
        case .removeMember:
            if member.userId == OIMManager.getLoginUser() {
                MessageModule.showMessage("You can't delete yourself.")
                return nil
            }
            if member.role == .owner {
                MessageModule.showMessage("The group owner could not be removed.")
                return nil
            }
        case .at:
            if member.userId == OIMManager.getLoginUser() {
                MessageModule.showMessage("Don't allow at yourself.")
                return nil
            }
        }
        return indexPath
    }
}
