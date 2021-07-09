//
//  GroupNoticeVC.swift
//  EEChat
//
//  Created by Snow on 2021/7/9.
//

import UIKit
import OpenIM

class GroupNoticeVC: BaseViewController {
    
    override class func show(param: Any? = nil, callback: BaseViewController.Callback? = nil) {
        _ = rxRequest(showLoading: true, action: { OIMManager.getGroupApplicationList(callback: $0) })
            .subscribe(onSuccess: { array in
                super.show(param: array, callback: callback)
            })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
