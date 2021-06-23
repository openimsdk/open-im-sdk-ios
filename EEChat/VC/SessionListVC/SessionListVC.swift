//
//  SessionListVC.swift
//  EEChat
//
//  Created by Snow on 2021/5/18.
//

import UIKit
import RxSwift
import RxCocoa
import OpenIM
import OpenIMUI

class SessionListVC: BaseViewController {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
     
        OIMManager.getConversationList { [weak self] result in
            guard let self = self else { return }
            if case let .success(array) = result {
                self.config(array: array)
            }
        }
    }
    
    private var array: [OIMConversation] = []
    
    private func bindAction() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SessionListCell.eec.nib(), forCellReuseIdentifier: "cell")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateConversation),
                                               name: OUIKit.onNewConversationNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateConversation),
                                               name: OUIKit.onConversationChangedNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onFriendProfileChanged),
                                               name: OUIKit.onFriendProfileChangedNotification,
                                               object: nil)
    }
    
    private func config(array: [OIMConversation]) {
        let uids = array.compactMap { conversation -> String? in
            let uid = conversation.userID
            if uid != "", !OUIKit.shared.hasUser(uid) {
                return uid
            }
            return nil
        }
        if uids.isEmpty {
            self.array = array
            self.tableView.reloadData()
            return
        }
        
        OUIKit.shared.getUsers(uids) { result in
            self.array = array
            self.tableView.reloadData()
        }
    }
    
    @objc
    func onFriendProfileChanged() {
        tableView.reloadData()
    }
    
    @objc
    func updateConversation(_ notification: Notification) {
        guard let array = notification.object as? [OIMConversation] else { return }
        config(array: array)
    }

}

extension SessionListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let model = array[indexPath.row]
        let isPinned = model.isPinned
        let title = isPinned ? "取消置顶" : "置顶"
        let top = UIContextualAction(style: .normal, title: title)
        { (action, view, completionHandler) in
            let isPinned = !isPinned
            
            OIMManager.pinConversation(model.conversationID, isPinned: isPinned) { result in
                self.tableView.performBatchUpdates {
                    var newRow: Int = {
                        if isPinned {
                            return 0
                        }
                        return self.array.firstIndex { !$0.isPinned } ?? self.array.count - 1
                    }()
                    model.isPinned = isPinned
                    if indexPath.row < newRow {
                        newRow -= 1
                    }
                    
                    self.array.remove(at: indexPath.row)
                    self.array.insert(model, at: newRow)
                    self.tableView.moveRow(at: indexPath, to: IndexPath(row: newRow, section: 0))
                }
            }
        }
        top.backgroundColor = UIColor.eec.rgb(0x1B72EC)

        let delete = UIContextualAction(style: .destructive, title: "删除")
        { (action, view, completionHandler) in
            OIMManager.deleteConversation(model.conversationID) { result in
                self.tableView.performBatchUpdates {
                    self.array.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
        delete.backgroundColor = UIColor.eec.rgb(0x7CBAFF)

        if model.unreadCount == 0 {
            return UISwipeActionsConfiguration(actions: [delete, top])
        }

        let read = UIContextualAction(style: .destructive, title: "标为已读")
        { (action, view, completionHandler) in
            OIMManager.markMessageAsRead(uid: model.userID, groupID: model.groupID) { _ in
                model.unreadCount = 0
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        read.backgroundColor = UIColor.eec.rgb(0xFFD576)

        return UISwipeActionsConfiguration(actions: [read, delete, top])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = array[indexPath.row]
        EEChatVC.show(conversation: model)
    }
    
}

extension SessionListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SessionListCell
        cell.model = array[indexPath.row]
        return cell
    }
}
