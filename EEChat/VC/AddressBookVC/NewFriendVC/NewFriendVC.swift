//
//  NewFriendVC.swift
//  EEChat
//
//  Created by Snow on 2021/4/21.
//

import UIKit
import RxCocoa
import OpenIM
import OpenIMUI

class NewFriendVC: BaseViewController {
    
    override class func show(param: Any? = nil, callback: BaseViewController.Callback? = nil) {
        _ = rxRequest(showLoading: true, callback: { OIMManager.getFriendApplicationList($0) })
            .subscribe(onSuccess: { array in
                super.show(param: array, callback: callback)
            })
    }

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
    }
    
    private lazy var relay = BehaviorRelay<[OIMFriendApplicationModel]>(value: [])
    
    private func bindAction() {
        assert(param is [OIMFriendApplicationModel])
        let array = param as! [OIMFriendApplicationModel]
        relay.accept(array)
        
        relay
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: NewFriendCell.self))
            { _, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(OIMFriendApplicationModel.self)
            .subscribe(onNext: { model in
                if model.flag == .agree {
                    OIMManager.getConversation(type: .c2c, id: model.info.uid) { result in
                        if case let .success(conversation) = result {
                            FriendSettingVC.show(param: conversation)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }

}
