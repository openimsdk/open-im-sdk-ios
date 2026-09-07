import Foundation

/// Manager handling message creation, sending, history retrieval, revoking, and searching.
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

    // MARK: - Message Creation Factory Methods
    public func createTextMessage(text: String) throws -> OpenIMMessageInfo {
        try adapter.createTextMessage(text: text)
    }

    public func createTextAtMessage(
        text: String,
        atUserIDs: [String],
        atUsersInfo: [OpenIMAtInfo] = [],
        quoteMessage: OpenIMMessageInfo? = nil
    ) throws -> OpenIMMessageInfo {
        try adapter.createTextAtMessage(
            text: text,
            atUserIDs: atUserIDs,
            atUsersInfo: atUsersInfo,
            quoteMessage: quoteMessage
        )
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
        try adapter.createVideoMessage(
            videoPath: videoPath,
            videoType: videoType,
            duration: duration,
            snapshotPath: snapshotPath
        )
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
        extension: String? = nil,
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

    // MARK: - Message Operations (Async/Await)
    public func sendMessage(
        message: OpenIMMessageInfo,
        recvID: String? = nil,
        groupID: String? = nil,
        offlinePushInfo: OpenIMOfflinePushInfo? = nil,
        isOnlineOnly: Bool = false,
        onProgress: ((Int) -> Void)? = nil
    ) async throws -> OpenIMMessageInfo {
        try await adapter.sendMessage(
            message: message,
            recvID: recvID,
            groupID: groupID,
            offlinePushInfo: offlinePushInfo,
            isOnlineOnly: isOnlineOnly,
            onProgress: onProgress
        )
    }

    public func getAdvancedHistoryMessageList(
        options: OpenIMGetMessageOptions
    ) async throws -> OpenIMGetAdvancedHistoryMessageListInfo {
        try await adapter.getAdvancedHistoryMessageList(options: options)
    }

    public func revokeMessage(conversationID: String, clientMsgID: String) async throws {
        try await adapter.revokeMessage(conversationID: conversationID, clientMsgID: clientMsgID)
    }

    public func typingStatusUpdate(recvID: String, msgTip: String) async throws {
        try await adapter.typingStatusUpdate(recvID: recvID, msgTip: msgTip)
    }

    public func markMessagesAsReadByMsgID(conversationID: String, clientMsgIDs: [String]) async throws {
        try await adapter.markMessagesAsReadByMsgID(conversationID: conversationID, clientMsgIDs: clientMsgIDs)
    }

    public func deleteMessage(conversationID: String, clientMsgID: String) async throws {
        try await adapter.deleteMessage(conversationID: conversationID, clientMsgID: clientMsgID)
    }

    public func deleteMessageFromLocalStorage(conversationID: String, clientMsgID: String) async throws {
        try await adapter.deleteMessageFromLocalStorage(conversationID: conversationID, clientMsgID: clientMsgID)
    }

    public func deleteAllMsgFromLocal() async throws {
        try await adapter.deleteAllMsgFromLocal()
    }

    public func deleteAllMsgFromLocalAndSvr() async throws {
        try await adapter.deleteAllMsgFromLocalAndSvr()
    }

    public func searchLocalMessages(param: OpenIMSearchParam) async throws -> OpenIMSearchResultInfo {
        try await adapter.searchLocalMessages(param: param)
    }
}
