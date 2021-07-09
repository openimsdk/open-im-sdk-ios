//
//  SearchUserVC.swift
//  EEChat
//
//  Created by Snow on 2021/4/21.
//

import UIKit
import OpenIM

class SearchUserVC: BaseViewController {

    @IBOutlet var tipsLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    lazy var conversationType: OIMConversationType = {
        assert(param is OIMConversationType)
        return param as! OIMConversationType
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        
        switch conversationType {
        case .c2c:
            tipsLabel.text = "Please enter account."
        case .group:
            tipsLabel.text = "Please enter group number"
        }
        addressLabel.text = LocalizedString("My account:") + AccountManager.shared.model.userInfo.uid
    }

    @IBOutlet var searchView: UIView!
    private func bindAction() {
        let views = (1...2).map{ view.viewWithTag($0)! }
        for (index, view) in views.enumerated() {
            view.rx.tapGesture()
                .when(.ended)
                .subscribe(onNext: { [unowned self] _ in
                    switch index {
                    case 0:
                        SearchNextUserVC.show(param: self.param)
                    case 1:
                        UIPasteboard.general.string = AccountManager.shared.model.userInfo.uid
                        MessageModule.showMessage(LocalizedString("The account has been copied!"))
                    default:
                        break
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}
