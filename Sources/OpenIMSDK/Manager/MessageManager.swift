import Foundation

/// Manager handling message creation, sending, history retrieval, and revocation.
public final class OpenIMMessageManager {
    private weak var client: OpenIMClient?
    private let adapter: OpenIMCoreAdapter

    init(client: OpenIMClient, adapter: OpenIMCoreAdapter) {
        self.client = client
        self.adapter = adapter
    }

    public func setListener(_ listener: OpenIMAdvancedMsgListener?) {
        adapter.setAdvancedMsgListener(listener)
    }

    // MARK: - Message Creation
    public func createTextMessage(text: String) throws -> OpenIMMessageInfo {
        try adapter.createTextMessage(text: text)
    }

    public func createTextAtMessage(
        text: String,
        atUserIDs: [String],
        atUsersInfo: [OpenIMAtInfo] = [],
        quoteMessage: OpenIMMessageInfo? = nil
    ) throws -> OpenIMMessageInfo {
        try adapter.createTextAtMessage(text: text, atUserIDs: atUserIDs, atUsersInfo: atUsersInfo, quoteMessage: quoteMessage)
    }

    public func createImageMessage(imagePath: String) throws -> OpenIMMessageInfo {
        try adapter.createImageMessage(imagePath: imagePath)
    }

    public func createSoundMessage(soundPath: String, duration: Int64) throws -> OpenIMMessageInfo {
        try adapter.createSoundMessage(soundPath: soundPath, duration: duration)
    }

    public func createVideoMessage(
        videoPath: String,
        videoType: String,
        duration: Int64,
        snapshotPath: String
    ) throws -> OpenIMMessageInfo {
        try adapter.createVideoMessage(videoPath: videoPath, videoType: videoType, duration: duration, snapshotPath: snapshotPath)
    }

    public func createFileMessage(filePath: String, fileName: String) throws -> OpenIMMessageInfo {
        try adapter.createFileMessage(filePath: filePath, fileName: fileName)
    }

    public func createLocationMessage(
        description: String,
        longitude: Double,
        latitude: Double
    ) throws -> OpenIMMessageInfo {
        try adapter.createLocationMessage(description: description, longitude: longitude, latitude: latitude)
    }

    public func createCustomMessage(
        data: String,
        `extension`: String? = nil,
        description: String? = nil
    ) throws -> OpenIMMessageInfo {
        try adapter.createCustomMessage(data: data, extension: `extension`, description: description)
    }

    public func createQuoteMessage(text: String, message: OpenIMMessageInfo) throws -> OpenIMMessageInfo {
        try adapter.createQuoteMessage(text: text, message: message)
    }

    public func createCardMessage(cardInfo: OpenIMCardElem) throws -> OpenIMMessageInfo {
        try adapter.createCardMessage(cardInfo: cardInfo)
    }

    public func createFaceMessage(index: Int, data: String) throws -> OpenIMMessageInfo {
        try adapter.createFaceMessage(index: index, data: data)
    }

    public func createMergerMessage(
        messageList: [OpenIMMessageInfo],
        title: String,
        summaryList: [String]
    ) throws -> OpenIMMessageInfo {
        try adapter.createMergerMessage(messageList: messageList, title: title, summaryList: summaryList)
    }

    public func createForwardMessage(message: OpenIMMessageInfo) throws -> OpenIMMessageInfo {
        try adapter.createForwardMessage(message: message)
    }

    // MARK: - Message Sending & Ops
    public func sendMessage(
        message: OpenIMMessageInfo,
        recvID: String? = nil,
        groupID: String? = nil,
        offlinePushInfo: OpenIMOfflinePushInfo? = nil,
        isOnlineOnly: Bool = false,
        onProgress: ((Int) -> Void)? = nil,
        completion: @escaping (Result<OpenIMMessageInfo, OpenIMError>) -> Void
    ) {
        adapter.sendMessage(
            message: message,
            recvID: recvID,
            groupID: groupID,
            offlinePushInfo: offlinePushInfo,
            isOnlineOnly: isOnlineOnly,
            onProgress: onProgress,
            completion: completion
        )
    }

    public func getAdvancedHistoryMessageList(
        options: OpenIMGetMessageOptions,
        completion: @escaping (Result<OpenIMGetAdvancedHistoryMessageListInfo, OpenIMError>) -> Void
    ) {
        adapter.getAdvancedHistoryMessageList(options: options, completion: completion)
    }

    public func revokeMessage(
        conversationID: String,
        clientMsgID: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.revokeMessage(conversationID: conversationID, clientMsgID: clientMsgID, completion: completion)
    }

    public func typingStatusUpdate(
        recvID: String,
        msgTip: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.typingStatusUpdate(recvID: recvID, msgTip: msgTip, completion: completion)
    }

    public func markMessagesAsReadByMsgID(
        conversationID: String,
        clientMsgIDs: [String],
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.markMessagesAsReadByMsgID(conversationID: conversationID, clientMsgIDs: clientMsgIDs, completion: completion)
    }

    public func deleteMessage(
        conversationID: String,
        clientMsgID: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.deleteMessage(conversationID: conversationID, clientMsgID: clientMsgID, completion: completion)
    }

    public func deleteMessageFromLocalStorage(
        conversationID: String,
        clientMsgID: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.deleteMessageFromLocalStorage(conversationID: conversationID, clientMsgID: clientMsgID, completion: completion)
    }

    public func deleteAllMsgFromLocal(
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.deleteAllMsgFromLocal(completion: completion)
    }

    public func deleteAllMsgFromLocalAndSvr(
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.deleteAllMsgFromLocalAndSvr(completion: completion)
    }

    public func searchLocalMessages(
        param: OpenIMSearchParam,
        completion: @escaping (Result<OpenIMSearchResultInfo, OpenIMError>) -> Void
    ) {
        adapter.searchLocalMessages(param: param, completion: completion)
    }
}

// MARK: - Async / Await Support (iOS 13.0+)
@available(iOS 13.0, macOS 10.15, *)
public extension OpenIMMessageManager {
    func sendMessage(
        message: OpenIMMessageInfo,
        recvID: String? = nil,
        groupID: String? = nil,
        offlinePushInfo: OpenIMOfflinePushInfo? = nil,
        isOnlineOnly: Bool = false,
        onProgress: ((Int) -> Void)? = nil
    ) async throws -> OpenIMMessageInfo {
        try await withCheckedThrowingContinuation { continuation in
            sendMessage(
                message: message,
                recvID: recvID,
                groupID: groupID,
                offlinePushInfo: offlinePushInfo,
                isOnlineOnly: isOnlineOnly,
                onProgress: onProgress
            ) { continuation.resume(with: $0) }
        }
    }

    func getAdvancedHistoryMessageList(options: OpenIMGetMessageOptions) async throws -> OpenIMGetAdvancedHistoryMessageListInfo {
        try await withCheckedThrowingContinuation { continuation in
            getAdvancedHistoryMessageList(options: options) { continuation.resume(with: $0) }
        }
    }

    func revokeMessage(conversationID: String, clientMsgID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            revokeMessage(conversationID: conversationID, clientMsgID: clientMsgID) { continuation.resume(with: $0) }
        }
    }

    func typingStatusUpdate(recvID: String, msgTip: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            typingStatusUpdate(recvID: recvID, msgTip: msgTip) { continuation.resume(with: $0) }
        }
    }

    func markMessagesAsReadByMsgID(conversationID: String, clientMsgIDs: [String]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            markMessagesAsReadByMsgID(conversationID: conversationID, clientMsgIDs: clientMsgIDs) { continuation.resume(with: $0) }
        }
    }

    func deleteMessage(conversationID: String, clientMsgID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            deleteMessage(conversationID: conversationID, clientMsgID: clientMsgID) { continuation.resume(with: $0) }
        }
    }

    func deleteMessageFromLocalStorage(conversationID: String, clientMsgID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            deleteMessageFromLocalStorage(conversationID: conversationID, clientMsgID: clientMsgID) { continuation.resume(with: $0) }
        }
    }

    func deleteAllMsgFromLocal() async throws {
        try await withCheckedThrowingContinuation { continuation in
            deleteAllMsgFromLocal { continuation.resume(with: $0) }
        }
    }

    func deleteAllMsgFromLocalAndSvr() async throws {
        try await withCheckedThrowingContinuation { continuation in
            deleteAllMsgFromLocalAndSvr { continuation.resume(with: $0) }
        }
    }

    func searchLocalMessages(param: OpenIMSearchParam) async throws -> OpenIMSearchResultInfo {
        try await withCheckedThrowingContinuation { continuation in
            searchLocalMessages(param: param) { continuation.resume(with: $0) }
        }
    }
}
