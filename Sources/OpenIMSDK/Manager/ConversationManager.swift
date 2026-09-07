import Foundation

/// Manager handling chat conversations, unread counters, pins, and drafts.
public final class OpenIMConversationManager {
    private weak var client: OpenIMClient?
    private let adapter: OpenIMCoreAdapter

    init(client: OpenIMClient, adapter: OpenIMCoreAdapter) {
        self.client = client
        self.adapter = adapter
    }

    public func setListener(_ listener: OpenIMConversationListener?) {
        adapter.setConversationListener(listener)
    }

    public func getAllConversationList() async throws -> [OpenIMConversationInfo] {
        try await adapter.getAllConversationList()
    }

    public func getConversationListSplit(
        offset: Int,
        count: Int
    ) async throws -> [OpenIMConversationInfo] {
        try await adapter.getConversationListSplit(offset: offset, count: count)
    }

    public func getOneConversation(
        sessionType: OpenIMConversationType,
        sourceID: String
    ) async throws -> OpenIMConversationInfo {
        try await adapter.getOneConversation(sessionType: sessionType, sourceID: sourceID)
    }

    public func getMultipleConversation(
        conversationIDs: [String]
    ) async throws -> [OpenIMConversationInfo] {
        try await adapter.getMultipleConversation(conversationIDs: conversationIDs)
    }

    public func setConversation(
        conversationID: String,
        req: OpenIMConversationReq
    ) async throws {
        try await adapter.setConversation(conversationID: conversationID, req: req)
    }

    public func hideConversation(conversationID: String) async throws {
        try await adapter.hideConversation(conversationID: conversationID)
    }

    public func setConversationDraft(
        conversationID: String,
        draftText: String
    ) async throws {
        try await adapter.setConversationDraft(conversationID: conversationID, draftText: draftText)
    }

    public func setConversationPinned(
        conversationID: String,
        isPinned: Bool
    ) async throws {
        try await adapter.setConversationPinned(conversationID: conversationID, isPinned: isPinned)
    }

    public func setConversationRecvMessageOpt(
        conversationIDs: [String],
        status: OpenIMReceiveMessageOpt
    ) async throws {
        try await adapter.setConversationRecvMessageOpt(conversationIDs: conversationIDs, status: status)
    }

    public func markConversationMessageAsRead(conversationID: String) async throws {
        try await adapter.markConversationMessageAsRead(conversationID: conversationID)
    }

    public func getTotalUnreadMsgCount() async throws -> Int {
        try await adapter.getTotalUnreadMsgCount()
    }

    public func deleteConversationAndDeleteAllMsg(conversationID: String) async throws {
        try await adapter.deleteConversationAndDeleteAllMsg(conversationID: conversationID)
    }

    public func clearConversationAndDeleteAllMsg(conversationID: String) async throws {
        try await adapter.clearConversationAndDeleteAllMsg(conversationID: conversationID)
    }
}
