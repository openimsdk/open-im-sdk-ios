//
//  GroupMemberVC.swift
//  EEChat
//
//  Created by Snow on 2021/7/7.
//

import UIKit
import OpenIM

class GroupMemberVC: BaseViewController {
    
    override class func show(param: Any? = nil, callback: BaseViewController.Callback? = nil) {
        assert(param is String)
        let groupID = param as! String
        _ = rxRequest(showLoading: true,
                      action: { OIMManager.getGroupMemberList(gid: groupID,
                                                              filter: .all,
                                                              next: 0,
                                                              callback: $0) })
            .subscribe(onSuccess: { result in
                super.show(param: result.data, callback: callback)
            })
    }

    @IBOutlet var memberView: GroupMemberView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberView.layout.sectionInset = UIEdgeInsets(top: 20, left: 22, bottom: 20, right: 22)
        memberView.layout.itemSize = CGSize(width: 42, height: 62)
        
        assert(param is [OIMGroupMember])
        let members = param as! [OIMGroupMember]
        memberView.members = members
    }

}
