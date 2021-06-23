//
//  IMConversationViewController.swift
//  MessageKit
//
//  Created by Snow on 2021/6/4.
//

import UIKit
import OpenIM
import MobileCoreServices

open class IMConversationViewController: UIViewController,
                                         IMInputViewControllerDelegate,
                                         MessagesDisplayDelegate,
                                         MessagesLayoutDelegate,
                                         MessagesDataSource,
                                         MessageCellDelegate,
                                         IMMessageViewControllerDelegate,
                                         OIMAdvancedMsgListener {
    
    public let conversation: OIMConversation
    
    public init(conversation: OIMConversation) {
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var moreMenus: [IMInputMoreItem] = [] {
        didSet {
            inputVC.moreView.items = moreMenus
        }
    }
    
    open lazy var inputVC: IMInputViewController = {
        let vc = IMInputViewController()
        vc.delegate = self
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame.size.height = 0
        return vc
    }()
    
    open lazy var messageVC: IMMessageViewController = {
        let vc = IMMessageViewController()
        vc.delegate = self
        vc.collectionView.messagesDisplayDelegate = self
        vc.collectionView.messagesLayoutDelegate = self
        vc.collectionView.messagesDataSource = self
        vc.collectionView.messageCellDelegate = self
        addChild(vc)
        view.addSubview(vc.view)
        return vc
    }()
    
    public private(set) var messages: [MessageType] = []
    
    public private(set) lazy var audioController = BasicAudioController(messageCollectionView: self.messageVC.collectionView)

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadMessage { [weak self] hasMore in
            guard let self = self else { return }
            self.messageVC.refreshControl(isDisplay: hasMore)
            OIMManager.addAdvancedMsgListener(self)
        }
        
        moreMenus = [
            IMInputMoreItem(title: LocalizedString("Shot"),
                            image: ImageCache.named("openim_icon_more_photo_shoot")),
            IMInputMoreItem(title: LocalizedString("Album"),
                            image: ImageCache.named("openim_icon_more_photo")),
            IMInputMoreItem(title: LocalizedString("Video"),
                            image: ImageCache.named("openim_icon_more_photo_shoot")),
            IMInputMoreItem(title: LocalizedString("File"),
                            image: ImageCache.named("openim_icon_more_photo_shoot")),
        ]
        
        inputVC.inputBarView.textView.text = conversation.draftText
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onFriendProfileChanged),
                                               name: OUIKit.onFriendProfileChangedNotification,
                                               object: nil)
    }
    
    deinit {
        OIMManager.removeAdvancedMsgListener(self)
    }
    
    public var responseKeyboard = false
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        responseKeyboard = true
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        responseKeyboard = false
        OIMManager.markMessageAsRead(uid: conversation.userID, groupID: conversation.groupID)
        OIMManager.setConversationDraft(conversation.conversationID, draftText: inputVC.inputBarView.textView.text)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        inputVC.view.frame = {
            var frame = inputVC.view.frame
            frame.origin.y = view.bounds.height - frame.height
            frame.size.width = view.bounds.width
            return frame
        }()
        
        messageVC.view.frame = {
            var frame = messageVC.view.frame
            frame.origin.y = view.safeAreaInsets.top
            frame.size.height = view.bounds.height - frame.origin.y - inputVC.view.frame.height
            return frame
        }()
    }
    
    @objc
    open func onFriendProfileChanged() {
        messageVC.collectionView.reloadData()
    }
    
    private func loadMessage(completeHandler: @escaping (_ hasMore: Bool) -> Void) {
        let count = 50
        OIMManager.getHistoryMessageList(uid: conversation.userID,
                                         groupID: conversation.groupID,
                                         firstMsg: messages.first?.innerMessage,
                                         count: count)
        { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let array):
                let collectionView = self.messageVC.collectionView
                let isEmpty = self.messages.isEmpty
                let array = array.map{ $0.toUIMessage() }
                self.messages.insert(contentsOf: self.preprocess(messages: array), at: 0)
                if isEmpty {
                    collectionView.reloadData()
                    collectionView.scrollToLastItem(at: .bottom, animated: false)
                } else {
                    collectionView.reloadDataAndKeepOffset()
                }
                completeHandler(array.count >= count)
            case .failure(_):
                completeHandler(true)
            }
        }
    }
    
    // MARK: - Methods
    
    public func append(_ messages: [MessageType], isScroll: Bool = true) {
        let row = self.messages.count
        let collectionView = messageVC.collectionView
        
        let messages = preprocess(messages: messages)
        collectionView.performBatchUpdates {
            let sections = (0..<messages.count).map { row + $0 }
            self.messages.insert(contentsOf: messages, at: row)
            collectionView.insertSections(IndexSet(sections))
        } completion: { (_) in
            if isScroll {
                self.messageVC.scrollToLastItem()
            }
        }
    }
    
    public func remove(_ message: MessageType) {
        guard let section = messages.firstIndex(of: message) else {
            return
        }
        
        let collectionView = messageVC.collectionView
        collectionView.performBatchUpdates {
            self.messages.remove(at: section)
            collectionView.deleteSections(IndexSet([section]))
        }
    }
    
    private func preprocess(messages: [MessageType]) -> [MessageType] {
        return messages.filter{ $0.isDisplay && !self.messages.contains($0) }
    }
    
    public func sendMessage(_ message: MessageType) {
        let conversation = self.conversation
        message.status = .none
        OIMManager.sendMessage(message.innerMessage,
                               receiver: conversation.userID,
                               groupID: conversation.groupID,
                               onlineUserOnly: false,
                               progress: MessageProcessor.shared.hookProgress(msgID: message.messageId))
        { [weak self] result in
            guard let self = self else { return }
            MessageProcessor.shared.removeProgress(msgID: message.messageId, isFinish: true)
            switch result {
            case .success:
                message.status = .success
            case .failure:
                message.status = .failure
                if let section = self.messages.firstIndex(of: message) {
                    self.messageVC.collectionView.reloadSections(IndexSet([section]))
                }
            }
        }
    }
    
    public func takePictureForSend() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.cameraCaptureMode = .photo
            vc.delegate = self
            self.present(vc, animated: true)
        } else {
            OUIKit.shared.messageDelegate?.showError(LocalizedString("Camera is not available"))
        }
    }
    
    public func selectPhotoForSend() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary),
           let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.mediaTypes = mediaTypes
            vc.delegate = self
            self.present(vc, animated: true)
        } else {
            OUIKit.shared.messageDelegate?.showError(LocalizedString("Album cannot be accessed"))
        }
    }
    
    public func takeVideoForSend() {
        if UIImagePickerController.isSourceTypeAvailable(.camera),
           let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)?.filter({ $0 == kUTTypeMovie as String }),
           !mediaTypes.isEmpty {
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.mediaTypes = mediaTypes
            vc.cameraCaptureMode = .video
            vc.videoQuality = .typeMedium
            vc.videoMaximumDuration = 30
            vc.delegate = self
            self.present(vc, animated: true)
        } else {
            OUIKit.shared.messageDelegate?.showError(LocalizedString("Camera is not available"))
        }
    }
    
    public func selectFileForSend() {
        let vc = UIDocumentPickerViewController(documentTypes: [kUTTypeData as String], in: .open)
        vc.delegate = self
        self.present(vc, animated: true)
    }

    // MARK: - OIMAdvancedMsgListener

    open func onRecvNewMessage(_ message: OIMMessage) {
        let message = message.toUIMessage()
        guard message.userID == conversation.userID, message.groupID == conversation.groupID else {
            return
        }
        self.append([message])
    }
    
    // MARK: - IMMessageViewControllerDelegate

    public func messageViewController(_ messageViewController: IMMessageViewController, loadMore completeHandler: @escaping (_ hasMore: Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.loadMessage(completeHandler: completeHandler)
        }
    }
    
    open func messageViewController(_ messageViewController: IMMessageViewController, showMenuForItemAt cell: MessageCollectionViewCell, message: MessageType) {
    }
    
    // MARK: - IMInputViewControllerDelegate
    
    open func inputViewController(_ inputViewController: IMInputViewController, didChange height: CGFloat) {
        guard responseKeyboard else {
            return
        }
        
        self.view.setNeedsLayout()
        UIView.animate(withDuration: CATransaction.animationDuration(),
                       delay: 0,
                       options: .curveEaseOut) { [weak self] in
            guard let self = self else {
                return
            }
            self.inputVC.view.frame.size.height = height
            self.view.layoutIfNeeded()
            self.messageVC.scrollToLastItem(at: .bottom, animated: false)
        }
    }
    
    open func inputViewController(_ inputViewController: IMInputViewController, didSendText text: String, at uids: [String]) {
        let message = OIMManager.createTextMessage(text, at: uids).toUIMessage()
        self.sendMessage(message)
        self.append([message])
    }
    
    open func inputViewController(_ inputViewController: IMInputViewController, didSendVoice url: URL) {
        do {
            let message = try MessageProcessor.shared.audio(url).toUIMessage()
            self.sendMessage(message)
            self.append([message])
        } catch {
            OUIKit.shared.messageDelegate?.showError(LocalizedString("The recording time is too short"))
        }
    }
    
    open func inputViewController(_ inputViewController: IMInputViewController, didSelectMore item: IMInputMoreItem, index: Int) {
        switch index {
        case 0:
            takePictureForSend()
        case 1:
            selectPhotoForSend()
        case 2:
            takeVideoForSend()
        case 3:
            selectFileForSend()
        default:
            break
        }
    }
    
    open func inputViewController(_ inputViewController: IMInputViewController, didInputAt completionHandler: @escaping (String, String) -> Void) {
        
    }
    
    open func inputViewController(_ inputViewController: IMInputViewController, didDeleteAt atText: String) {
        
    }
    
    // MARK: - MessagesDisplayDelegate
    
    open func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        let message = messages[indexPath.section]
        
        let view = messagesCollectionView.dequeueReusableHeaderView(MessageReusableDateView.self, for: indexPath)
        
        view.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        return view
    }
    
    open func configureAvatarView(_ avatarView: MessageImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.layer.cornerRadius = avatarView.bounds.height * 0.5
        avatarView.image = ImageCache.named("openim_icon_default_avatar")
        
        let user = OUIKit.shared.getUser(message.sendID) { user in
            if user != nil {
                self.messageVC.collectionView.reloadData()
            }
        }
        if let user = user {
            avatarView.setImage(with: user.icon, placeholder: avatarView.image)
        }
    }
    
    open func configureAccessoryView(_ accessoryView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        accessoryView.isHidden = true
        if message.isSelf {
            if message.status == .failure {
                accessoryView.isHidden = false
                accessoryView.image = ImageCache.named("openim_icon_send_error")
            }
        } else {
            if case ContentType.audio = message.content,
               !message.isRead {
                accessoryView.isHidden = false
                accessoryView.image = ImageCache.named("openim_icon_voice_unclicked")
            }
        }
    }

    open func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        audioController.configureAudioCell(cell, message: message)
    }
    
    // MARK: - MessagesLayoutDelegate
    
    open func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        let message = messages[section]
        if section > 0 {
            let prevMessage = messages[section - 1]
            if message.sendTime - prevMessage.sendTime < 5 * 60 {
                return .zero
            }
        }
        
        let itemWidth = messagesCollectionView.messagesCollectionViewFlowLayout.itemWidth
        return CGSize(width: itemWidth, height: 30)
    }
    
    open func nameLabelIsHidden(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        if !conversation.userID.isEmpty {
            return true
        }
        return message.isSelf
    }
    
    // MARK: - MessagesDataSource

    open func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    open func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    open func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {
        fatalError()
    }

    open func nameLabelAttributedText(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> NSAttributedString? {
        return nil
    }
    
    // MARK: - MessageCellDelegate
    
    open func didTapImage(in cell: MessageCollectionViewCell) {
        let collectionView = messageVC.collectionView
        guard let indexPath = collectionView.indexPath(for: cell),
            let message = collectionView.messagesDataSource?.messageForItem(at: indexPath, in: collectionView) else {
                return
        }
        if case let .image(item) = message.content {
            if let url = item.url {
                let vc = IMImageViewController(url: url)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    open func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        let collectionView = messageVC.collectionView
        guard let indexPath = collectionView.indexPath(for: cell),
            let message = collectionView.messagesDataSource?.messageForItem(at: indexPath, in: collectionView) else {
                return
        }
        
        if message.isSelf, message.status.rawValue < MessageType.Status.success.rawValue {
            sendMessage(message)
            collectionView.reloadItems(at: [indexPath])
        }
    }

    open func didTapPlayButton(in cell: AudioMessageCell) {
        let collectionView = messageVC.collectionView
        guard let indexPath = collectionView.indexPath(for: cell),
            let message = collectionView.messagesDataSource?.messageForItem(at: indexPath, in: collectionView) else {
                return
        }
        
        audioController.playOrStopSound(for: message, in: cell)
        if !message.isRead {
            message.isRead = true
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    open func didTapPlayButton(in cell: VideoMessageCell) {
        let collectionView = messageVC.collectionView
        guard let indexPath = collectionView.indexPath(for: cell),
            let message = collectionView.messagesDataSource?.messageForItem(at: indexPath, in: collectionView) else {
                return
        }
        
        if case let .video(item) = message.content {
            if let url = item.url {
                let vc = IMVideoViewController(url: url)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension IMConversationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.delegate = nil
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let mediaType = info[.mediaType] as! CFString
            switch mediaType {
            case kUTTypeImage:
                let url = info[.imageURL] as? URL
                let image = info[.originalImage] as! UIImage
                let message = MessageProcessor.shared.image(image, url: url).toUIMessage()
                self.sendMessage(message)
                self.append([message])
            case kUTTypeMovie:
                let url = info[.mediaURL] as! URL
                MessageProcessor.shared.video(url) { message in
                    if let message = message?.toUIMessage() {
                        self.sendMessage(message)
                        self.append([message])
                    }
                }
            default:
                break
            }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension IMConversationViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        urls.forEach { url in
            _ = url.startAccessingSecurityScopedResource()
            let message = MessageProcessor.shared.file(url).toUIMessage()
            self.sendMessage(message)
            self.append([message])
            url.stopAccessingSecurityScopedResource()
        }
        controller.dismiss(animated: true)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}
