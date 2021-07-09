//
//  AddressBookVC.swift
//  EEChat
//
//  Created by Snow on 2021/4/8.
//

import UIKit
import RxCocoa
import RxDataSources
import OpenIM
import OpenIMUI

class AddressBookVC: BaseViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var redLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reqFriendApplicationList),
                                               name: OUIKit.onFriendApplicationListAddedNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reqFriendApplicationList),
                                               name: OUIKit.onFriendListAddedNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reqFriend),
                                               name: OUIKit.onFriendListAddedNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reqFriend),
                                               name: OUIKit.onFriendListDeletedNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reqFriend),
                                               name: OUIKit.onFriendProfileChangedNotification,
                                               object: nil)
        
        request()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private let relay = BehaviorRelay<[SectionModel<String, OIMUser>]>(value: [])
    private func bindAction() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, OIMUser>>(
            configureCell: { _, tv, _, element in
                let cell = tv.dequeueReusableCell(withIdentifier: "cell")! as! AddressBookCell
                cell.model = element

                return cell
            },
            canMoveRowAtIndexPath: { _, _ in
                return false
            },
            sectionIndexTitles: { dataSource in
                dataSource.sectionModels.map({ $0.model })
            }
        )
        
        tableView.register(AddressBookHeaderView.eec.nib(), forHeaderFooterViewReuseIdentifier: "header")
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(OIMUser.self)
            .subscribe(onNext: { model in
                SearchUserDetailsVC.show(param: model.uid)
            })
            .disposed(by: disposeBag)
        
        relay
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func request() {
        reqFriend()
        reqFriendApplicationList()
    }
    
    @objc
    private func reqFriend() {
        rxRequest(showError: false, action: { OIMManager.getFriendList($0) })
            .subscribe(onSuccess: { [unowned self] array in
                self.refresh(array: array)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    private func reqFriendApplicationList() {
        rxRequest(showError: false, action: { OIMManager.getFriendApplicationList($0) })
            .subscribe(onSuccess: { [unowned self] array in
                let filter = array.filter{ $0.flag == .default }
                self.redLabel.text = filter.count.description
                self.redLabel.superview?.isHidden = filter.isEmpty
            })
            .disposed(by: disposeBag)
    }
    
    private func refresh(array: [OIMUser]) {
        let items = array
            .sorted(by: { (model0, model1) -> Bool in
                return model0.getName() < model1.getName()
            })
            .reduce(into: [String: SectionModel<String, OIMUser>](), { (result, model) in
                let key: String = {
                    let name = model.getName()
                    if name.count > 0 {
                        let first = String(name.first!)
                        if Int(first) == nil {
                            return String(first.eec_pinyin().first!)
                        }
                    }
                    return "*"
                }()

                if result[key] == nil {
                    result[key] = SectionModel<String, OIMUser>(model: key, items: [])
                }
                result[key]!.items.append(model)
            })
            .reduce(into: [SectionModel<String, OIMUser>]()) { (result, args) in
                let (_, value) = args
                result.append(value)
            }
            .sorted { (model0, model1) -> Bool in
                return model0.model < model1.model
            }
        
        relay.accept(items)
    }

    // MARK: - Action
    @IBAction func newFriendAction() {
        NewFriendVC.show()
    }
    
}

extension AddressBookVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
            as! AddressBookHeaderView
        view.titleLabel.text = relay.value[section].model
        return view
    }
}
