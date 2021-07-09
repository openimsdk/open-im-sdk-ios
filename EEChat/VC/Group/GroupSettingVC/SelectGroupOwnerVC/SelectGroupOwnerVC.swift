//
//  SelectGroupOwnerVC.swift
//  EEChat
//
//  Created by Snow on 2021/7/8.
//

import UIKit
import RxCocoa
import OpenIM

class SelectGroupOwnerVC: BaseViewController {
    
    override class func show(param: Any? = nil, callback: BaseViewController.Callback? = nil) {
        assert(param is String)
        let groupID = param as! String
        _ = rxRequest(showLoading: true, action: { OIMManager.getGroupMemberList(gid: groupID,
                                                                                   filter: .all,
                                                                                   next: 0,
                                                                                   callback: $0) })
            .subscribe(onSuccess: { result in
                super.show(param: result, callback: callback)
            })
    }

    @IBOutlet var tableView: UITableView!
    
    lazy var result: OIMManager.GroupMemberListResult = {
        assert(param is OIMManager.GroupMemberListResult)
        return param as! OIMManager.GroupMemberListResult
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
    }
    
    private func bindAction() {
        tableView.register(LaunchGroupChatCell.eec.nib(), forCellReuseIdentifier: "cell")
        
        let relay = BehaviorRelay<[OIMGroupMember]>(value: result.data)
        relay
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: LaunchGroupChatCell.self)) { _, element, cell in
                cell.model = element
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(OIMGroupMember.self)
            .subscribe(onNext: { member in
                guard member.role != .owner else {
                    MessageModule.showMessage("You already have the group!")
                    return
                }
                
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
            })
            .disposed(by: disposeBag)
        
    }
    
}
