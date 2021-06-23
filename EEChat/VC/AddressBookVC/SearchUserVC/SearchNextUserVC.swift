//
//  SearchNextUserVC.swift
//  EEChat
//
//  Created by Snow on 2021/4/21.
//

import UIKit
import OpenIM

class SearchNextUserVC: BaseViewController {
    
    override class func show(param: Any? = nil, callback: BaseViewController.Callback? = nil) {
        let vc = self.vc(param: param, callback: callback)
        NavigationModule.shared.presentCustom(vc)
    }

    @IBOutlet var textField: UITextField!
    @IBOutlet var notFoundView: UIView!
    @IBOutlet var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        refresh(isSearch: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func bindAction() {
        textField.rx.text
            .map({ [unowned self] (text) -> Bool in
                self.addressLabel.text = text
                return text!.isEmpty
            })
            .subscribe(onNext: { [unowned self] isCollapsed in
                self.addressLabel.eec_collapsed = isCollapsed
            })
            .disposed(by: disposeBag)
        
        textField.becomeFirstResponder()
    }
    
    func refresh(isSearch: Bool) {
        if isSearch {
            addressLabel.eec_collapsed = textField.text!.isEmpty || !isSearch
            notFoundView.eec_collapsed = isSearch
        } else {
            addressLabel.eec_collapsed = !isSearch
            notFoundView.eec_collapsed = isSearch
        }
    }
    
    @IBAction func searchAction() {
        textField.isUserInteractionEnabled = false
        let uid = textField.text!
        rxRequest(showLoading: true, callback: { OIMManager.getUsers(uids: [uid], callback: $0) })
            .subscribe(onSuccess: { [unowned self] array in
                if array.isEmpty {
                    self.refresh(isSearch: false)
                } else {
                    SearchUserDetailsVC.show(param: array.first)
                }
            }, onFailure: { [unowned self] error in
                self.refresh(isSearch: false)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func dismissAction() {
        if textField.isUserInteractionEnabled {
            NavigationModule.shared.dismiss(self)
        } else {
            textField.isUserInteractionEnabled = true
            refresh(isSearch: true)
        }
    }
    
}
