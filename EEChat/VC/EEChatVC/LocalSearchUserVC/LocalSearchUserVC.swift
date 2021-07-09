//
//  LocalSearchUserVC.swift
//  EEChat
//
//  Created by Snow on 2021/4/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import OpenIM
import OpenIMUI

class LocalSearchUserVC: BaseViewController {

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
    }
    
    @IBOutlet var textField: UITextField!
    
    lazy var relay = BehaviorRelay<[SectionModel<String, Any>]>(value: [])
    private var conversationList: [OIMConversation] = []
    
    private func bindAction() {
        switch param {
        case nil:
            title = LocalizedString("Search")
            tableView.rx.modelSelected(Any.self)
                .subscribe(onNext: { model in
                    switch model {
                    case let model as OIMUser:
                        SearchUserDetailsVC.show(param: model.uid)
                    case let model as OIMConversation:
                        if model.groupID != "" {
                            SearchUserDetailsVC.show(param: model.userID)
                        }
                    default:
                        break
                    }
                })
                .disposed(by: disposeBag)
        case let message as MessageType:
            title = LocalizedString("Select")
            tableView.rx.modelSelected(Any.self)
                .subscribe(onNext: { [unowned self] model in
                    self.forward(model: model, messages: [message])
                })
                .disposed(by: disposeBag)
        case let messages as [MessageType]:
            title = LocalizedString("Select")
            tableView.rx.modelSelected(Any.self)
                .subscribe(onNext: { [unowned self] model in
                    self.forward(model: model, messages: messages)
                })
                .disposed(by: disposeBag)
        default:
            fatalError()
        }
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Any>>(
            configureCell: { _, tv, _, element in
                let cell = tv.dequeueReusableCell(withIdentifier: "cell")! as! LocalSearchUserCell
                cell.model = element

                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                dataSource[sectionIndex].model
            },
            canMoveRowAtIndexPath: { _, _ in
                return false
            }
        )
        
        relay
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        OIMManager.getConversationList { [weak self] result in
            guard let self = self else { return }
            if case let .success(array) = result {
                self.conversationList = array
                self.reload(users: [])
            }
        }
        
        textField.rx.text
            .skip(1)
            .debounce(DispatchTimeInterval.microseconds(500), scheduler: MainScheduler.instance)
            .startWith("")
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                
                if let key = text?.lowercased(), key != "" {
                    OIMManager.getFriendList { result in
                        if case let .success(array) = result {
                            let user = array.filter {
                                $0.name.range(of: key, options: .caseInsensitive) != nil
                                    || $0.comment.range(of: key, options: .caseInsensitive) != nil
                            }
                            self.reload(users: user)
                        }
                    }
                } else {
                    self.reload(users: [])
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func reload(users: [OIMUser]) {
        var array: [SectionModel<String, Any>] = [SectionModel(model: "", items: users as [Any])]
        if conversationList.count > 0 {
            array.append(SectionModel(model: LocalizedString("Recent Session"), items: conversationList as [Any]))
        }
        relay.accept(array)
    }
    
    private func forward(model: Any, messages: [MessageType]) {
        let (uid, groupID, name): (String, String, String) = {
            switch model {
            case let model as OIMUser:
                return (model.uid, "", model.getName())
            case let model as OIMConversation:
                return (model.userID, model.groupID, model.showName)
            default:
                fatalError()
            }
        }()
        UIAlertController.show(title: String(format: LocalizedString("Send to %@?"), name),
                               message: nil,
                               buttons: [LocalizedString("Yes")],
                               cancel: LocalizedString("No"))
        { (index) in
            if index == 1 {
                for message in messages {

                }
                MessageModule.showMessage(LocalizedString("Sent"))
            }
        }
    }
}
