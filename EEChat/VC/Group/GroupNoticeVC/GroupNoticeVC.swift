//
//  GroupNoticeVC.swift
//  EEChat
//
//  Created by Snow on 2021/7/9.
//

import UIKit
import RxCocoa
import OpenIM

class GroupNoticeVC: BaseViewController {
    
    override class func show(param: Any? = nil, callback: BaseViewController.Callback? = nil) {
        _ = rxRequest(showLoading: true, action: { OIMManager.getGroupApplicationList(callback: $0) })
            .subscribe(onSuccess: { array in
                super.show(param: array, callback: callback)
            })
    }
    
    lazy var applications: [OIMGroupApplication] = {
        assert(param is [OIMGroupApplication])
        return param as! [OIMGroupApplication]
    }()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
    }
    
    lazy var relay = BehaviorRelay(value: applications)
    
    private func bindAction() {
        relay
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: GroupNoticeCell.self))
            { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
    }
}
