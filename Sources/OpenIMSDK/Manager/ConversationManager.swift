import Foundation

/// Manager handling conversations, pinned status, unread counts, and drafts.
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

    public func getAllConversationList(
        completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void
    ) {
        adapter.getAllConversationList(completion: completion)
    }

    public func getConversationListSplit(
        offset: Int,
        count: Int,
        completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void
    ) {
        adapter.getConversationListSplit(offset: offset, count: count, completion: completion)
    }

    public func getOneConversation(
        sessionType: OpenIMConversationType,
        sourceID: String,
        completion: @escaping (Result<OpenIMConversationInfo, OpenIMError>) -> Void
    ) {
        adapter.getOneConversation(sessionType: sessionType, sourceID: sourceID, completion: completion)
    }

    public func getMultipleConversation(
        conversationIDs: [String],
        completion: @escaping (Result<[OpenIMConversationInfo], OpenIMError>) -> Void
    ) {
        adapter.getMultipleConversation(conversationIDs: conversationIDs, completion: completion)
    }

    public func setConversation(
        conversationID: String,
        req: OpenIMConversationReq,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.setConversation(conversationID: conversationID, req: req, completion: completion)
    }

    public func hideConversation(
        conversationID: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.hideConversation(conversationID: conversationID, completion: completion)
    }

    public func setConversationDraft(
        conversationID: String,
        draftText: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.setConversationDraft(conversationID: conversationID, draftText: draftText, completion: completion)
    }

    public func setConversationPinned(
        conversationID: String,
        isPinned: Bool,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.setConversationPinned(conversationID: conversationID, isPinned: isPinned, completion: completion)
    }

    public func setConversationRecvMessageOpt(
        conversationIDs: [String],
        status: OpenIMReceiveMessageOpt,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.setConversationRecvMessageOpt(conversationIDs: conversationIDs, status: status, completion: completion)
    }

    public func markConversationMessageAsRead(
        conversationID: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.markConversationMessageAsRead(conversationID: conversationID, completion: completion)
    }

    public func getTotalUnreadMsgCount(
        completion: @escaping (Result<Int, OpenIMError>) -> Void
    ) {
        adapter.getTotalUnreadMsgCount(completion: completion)
    }

    public func deleteConversationAndDeleteAllMsg(
        conversationID: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.deleteConversationAndDeleteAllMsg(conversationID: conversationID, completion: completion)
    }

    public func clearConversationAndDeleteAllMsg(
        conversationID: String,
        completion: @escaping (Result<Void, OpenIMError>) -> Void
    ) {
        adapter.clearConversationAndDeleteAllMsg(conversationID: conversationID, completion: completion)
    }
}

// MARK: - Async / Await Support (iOS 13.0+)
@available(iOS 13.0, macOS 10.15, *)
public extension OpenIMConversationManager {
    func getAllConversationList() async throws -> [OpenIMConversationInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getAllConversationList { continuation.resume(with: $0) }
        }
    }

    func getConversationListSplit(offset: Int, count: Int) async throws -> [OpenIMConversationInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getConversationListSplit(offset: offset, count: count) { continuation.resume(with: $0) }
        }
    }

    func getOneConversation(sessionType: OpenIMConversationType, sourceID: String) async throws -> OpenIMConversationInfo {
        try await withCheckedThrowingContinuation { continuation in
            getOneConversation(sessionType: sessionType, sourceID: sourceID) { continuation.resume(with: $0) }
        }
    }

    func getMultipleConversation(conversationIDs: [String]) async throws -> [OpenIMConversationInfo] {
        try await withCheckedThrowingContinuation { continuation in
            getMultipleConversation(conversationIDs: conversationIDs) { continuation.resume(with: $0) }
        }
    }

    func setConversation(conversationID: String, req: OpenIMConversationReq) async throws {
        try await withCheckedThrowingContinuation { continuation in
            setConversation(conversationID: conversationID, req: req) { continuation.resume(with: $0) }
        }
    }

    func hideConversation(conversationID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            hideConversation(conversationID: conversationID) { continuation.resume(with: $0) }
        }
    }

    func setConversationDraft(conversationID: String, draftText: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            setConversationDraft(conversationID: conversationID, draftText: draftText) { continuation.resume(with: $0) }
        }
    }

    func setConversationPinned(conversationID: String, isPinned: Bool) async throws {
        try await withCheckedThrowingContinuation { continuation in
            setConversationPinned(conversationID: conversationID, isPinned: isPinned) { continuation.resume(with: $0) }
        }
    }

    func setConversationRecvMessageOpt(conversationIDs: [String], status: OpenIMReceiveMessageOpt) async throws {
        try await withCheckedThrowingContinuation { continuation in
            setConversationRecvMessageOpt(conversationIDs: conversationIDs, status: status) { continuation.resume(with: $0) }
        }
    }

    func markConversationMessageAsRead(conversationID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            markConversationMessageAsRead(conversationID: conversationID) { continuation.resume(with: $0) }
        }
    }

    func getTotalUnreadMsgCount() async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            getTotalUnreadMsgCount { continuation.resume(with: $0) }
        }
    }

    func deleteConversationAndDeleteAllMsg(conversationID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            deleteConversationAndDeleteAllMsg(conversationID: conversationID) { continuation.resume(with: $0) }
        }
    }

    func clearConversationAndDeleteAllMsg(conversationID: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            clearConversationAndDeleteAllMsg(conversationID: conversationID) { continuation.resume(with: $0) }
        }
    }
}
