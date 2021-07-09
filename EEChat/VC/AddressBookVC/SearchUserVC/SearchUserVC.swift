//
//  SearchUserVC.swift
//  EEChat
//
//  Created by Snow on 2021/4/21.
//

import UIKit

class SearchUserVC: BaseViewController {

    @IBOutlet var addressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        
        addressLabel.text = LocalizedString("My account:") + AccountManager.shared.model.userInfo.uid
    }

    @IBOutlet var searchView: UIView!
    private func bindAction() {
        let views = (1...2).map{ view.viewWithTag($0)! }
        for (index, view) in views.enumerated() {
            view.rx.tapGesture()
                .when(.ended)
                .subscribe(onNext: { _ in
                    switch index {
                    case 0:
                        SearchNextUserVC.show()
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
