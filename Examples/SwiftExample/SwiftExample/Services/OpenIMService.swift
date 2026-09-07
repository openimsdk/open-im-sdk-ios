//
//  OpenIMService.swift
//  SwiftExample
//
//  Created for OpenIM iOS SDK Standalone Swift Example.
//

import Foundation
import Combine
import OpenIMSDK

public struct LogEntry: Identifiable, Equatable {
    public let id = UUID()
    public let timestamp: Date
    public let message: String
    public let level: LogLevel

    public enum LogLevel: String {
        case info = "INFO"
        case success = "OK"
        case warning = "WARN"
        case error = "ERR"
    }

    public var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: timestamp)
    }
}

@MainActor
public final class OpenIMService: NSObject, ObservableObject,
    OpenIMConversationListener,
    OpenIMAdvancedMsgListener,
    OpenIMFriendshipListener,
    OpenIMGroupListener,
    OpenIMUserListener {

    public static let shared = OpenIMService()

    // MARK: - Core Client
    public let client: OpenIMClient
    private var eventObserverID: UUID?

    // MARK: - Published States
    @Published public var connectionState: String = "Disconnected"
    @Published public var isConnected: Bool = false
    @Published public var isLoggedIn: Bool = false
    @Published public var isBusy: Bool = false
    @Published public var errorMessage: String?

    // Current User & Auth
    @Published public var apiAddr: String = "https://web.openim.io/api"
    @Published public var wsAddr: String = "wss://web.openim.io/msg_gateway"
    @Published public var currentUserID: String = "6932496926"
    @Published public var currentToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3OTYyODg0MDQsImlhdCI6MTc4ODUxMjM5OSwiVXNlcklEIjoiNjkzMjQ5NjkyNiIsIlBsYXRmb3JtSUQiOjJ9.G6VU8pqEdkNniUG7XeMcPxsjWPOaxsIuCjEUtvJeF_8"
    @Published public var currentUser: OpenIMUserInfo?

    // Business Data
    @Published public var conversations: [OpenIMConversationInfo] = []
    @Published public var totalUnreadCount: Int = 0
    @Published public var friends: [OpenIMFriendInfo] = []
    @Published public var friendRequests: [OpenIMFriendApplication] = []
    @Published public var groups: [OpenIMGroupInfo] = []

    // Active Chat State
    @Published public var activeConversationID: String?
    @Published public var activeChatMessages: [OpenIMMessageInfo] = []

    // Live Logs
    @Published public var logs: [LogEntry] = []

    public init(client: OpenIMClient = OpenIMClient()) {
        self.client = client
        super.init()
        setupListeners()
    }

    deinit {
        if let id = eventObserverID {
            client.removeEventObserver(id)
        }
    }

    // MARK: - Listener & Event Setup
    private func setupListeners() {
        eventObserverID = client.observeEvents { [weak self] event in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                switch event {
                case .connecting:
                    self.connectionState = "Connecting..."
                    self.isConnected = false
                    self.log("Core event: Connecting to gateway...", level: .info)
                case .connected:
                    self.connectionState = "Connected"
                    self.isConnected = true
                    self.log("Core event: Connected to gateway", level: .success)
                case let .connectionFailed(code, msg):
                    self.connectionState = "Failed (\(code))"
                    self.isConnected = false
                    self.log("Core event: Connection failed: \(msg ?? "code \(code)")", level: .error)
                case .kickedOffline:
                    self.connectionState = "Kicked Offline"
                    self.isConnected = false
                    self.isLoggedIn = false
                    self.log("Core event: Account was kicked offline", level: .warning)
                case .tokenExpired:
                    self.connectionState = "Token Expired"
                    self.isConnected = false
                    self.isLoggedIn = false
                    self.log("Core event: Token expired", level: .warning)
                case let .tokenInvalid(msg):
                    self.connectionState = "Token Invalid"
                    self.isConnected = false
                    self.isLoggedIn = false
                    self.log("Core event: Token invalid: \(msg ?? "")", level: .error)
                }
            }
        }

        client.setConversationListener(self)
        client.setAdvancedMsgListener(self)
        client.setFriendshipListener(self)
        client.setGroupListener(self)
        client.setUserListener(self)
    }

    public func log(_ message: String, level: LogEntry.LogLevel = .info) {
        let entry = LogEntry(timestamp: Date(), message: message, level: level)
        logs.insert(entry, at: 0)
        if logs.count > 200 {
            logs.removeLast()
        }
    }

    public func clearLogs() {
        logs.removeAll()
    }

    // MARK: - SDK Initialization & Login/Logout
    public func initializeSDK() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let dataDir = docs?.appendingPathComponent("OpenIM_SwiftExample_Data")
        if let dataDir = dataDir {
            try? FileManager.default.createDirectory(at: dataDir, withIntermediateDirectories: true)
        }

        let config = OpenIMConfiguration(
            apiAddress: apiAddr,
            websocketAddress: wsAddr,
            dataDirectory: dataDir,
            platform: .android,
            logLevel: 5
        )

        do {
            try client.initialize(configuration: config)
            log("OpenIM SDK initialized successfully", level: .success)
        } catch {
            log("SDK initialization error: \(error.localizedDescription)", level: .error)
        }
    }

    public func login() async {
        guard !currentUserID.isEmpty, !currentToken.isEmpty else {
            errorMessage = "Please enter both User ID and Token."
            return
        }

        isBusy = true
        errorMessage = nil

        do {
            if client.state == .idle {
                initializeSDK()
            }
            log("Logging in as \(currentUserID)...", level: .info)
            try await client.login(userID: currentUserID, token: currentToken)
            isLoggedIn = true
            log("Async login succeeded! Syncing user data...", level: .success)
            await refreshAll()
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
            log("Login error: \(error)", level: .error)
        }

        isBusy = false
    }

    public func logout() async {
        isBusy = true
        do {
            log("Logging out...", level: .info)
            try await client.logout()
            isLoggedIn = false
            currentUser = nil
            conversations.removeAll()
            friends.removeAll()
            friendRequests.removeAll()
            groups.removeAll()
            activeChatMessages.removeAll()
            activeConversationID = nil
            log("Logged out successfully", level: .success)
        } catch {
            errorMessage = "Logout failed: \(error.localizedDescription)"
            log("Logout error: \(error)", level: .error)
        }
        isBusy = false
    }

    // MARK: - Data Synchronization
    public func refreshAll() async {
        await fetchUserProfile()
        await fetchConversations()
        await fetchFriends()
        await fetchFriendRequests()
        await fetchGroups()
    }

    public func fetchUserProfile() async {
        do {
            currentUser = try await client.user.getSelfUserInfo()
            log("Fetched user profile: \(currentUser?.nickname ?? currentUser?.userID ?? "-")", level: .info)
        } catch {
            log("Fetch self info failed: \(error.localizedDescription)", level: .error)
        }
    }

    public func fetchConversations() async {
        do {
            conversations = try await client.conversation.getAllConversationList()
            totalUnreadCount = try await client.conversation.getTotalUnreadMsgCount()
            log("Fetched \(conversations.count) conversations (Total unread: \(totalUnreadCount))", level: .info)
        } catch {
            log("Fetch conversations error: \(error.localizedDescription)", level: .error)
        }
    }

    public func fetchFriends() async {
        do {
            friends = try await client.friend.getFriendList(filterBlack: false)
            log("Fetched \(friends.count) friends", level: .info)
        } catch {
            log("Fetch friends error: \(error.localizedDescription)", level: .error)
        }
    }

    public func fetchFriendRequests() async {
        do {
            friendRequests = try await client.friend.getFriendApplicationListAsRecipient()
            log("Fetched \(friendRequests.count) pending friend requests", level: .info)
        } catch {
            log("Fetch friend requests error: \(error.localizedDescription)", level: .error)
        }
    }

    public func fetchGroups() async {
        do {
            groups = try await client.group.getJoinedGroupList()
            log("Fetched \(groups.count) joined groups", level: .info)
        } catch {
            log("Fetch groups error: \(error.localizedDescription)", level: .error)
        }
    }

    // MARK: - Conversation Operations
    public func pinConversation(conversationID: String, isPinned: Bool) async {
        do {
            try await client.conversation.setConversationPinned(conversationID: conversationID, isPinned: isPinned)
            log("Toggled pin state for \(conversationID) -> \(isPinned)", level: .info)
            await fetchConversations()
        } catch {
            errorMessage = "Pin failed: \(error.localizedDescription)"
            log("Pin error: \(error)", level: .error)
        }
    }

    public func markConversationAsRead(conversationID: String) async {
        do {
            try await client.conversation.markConversationMessageAsRead(conversationID: conversationID)
            log("Marked conversation as read: \(conversationID)", level: .info)
            await fetchConversations()
        } catch {
            log("Mark read error: \(error.localizedDescription)", level: .error)
        }
    }

    public func deleteConversation(conversationID: String) async {
        do {
            try await client.conversation.deleteConversationAndDeleteAllMsg(conversationID: conversationID)
            log("Deleted conversation: \(conversationID)", level: .info)
            await fetchConversations()
        } catch {
            errorMessage = "Delete failed: \(error.localizedDescription)"
            log("Delete conversation error: \(error)", level: .error)
        }
    }

    // MARK: - Messaging & Chat Operations
    public func loadChatMessages(conversationID: String) async {
        activeConversationID = conversationID
        do {
            let options = OpenIMGetMessageOptions(conversationID: conversationID, count: 50)
            let result = try await client.message.getAdvancedHistoryMessageList(options: options)
            let list = result.messageList ?? []
            activeChatMessages = list
            log("Loaded \(list.count) messages for conversation \(conversationID)", level: .info)
            await markConversationAsRead(conversationID: conversationID)
        } catch {
            log("Load chat messages error: \(error.localizedDescription)", level: .error)
        }
    }

    public func sendTextMessage(text: String, recvID: String?, groupID: String?) async {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        do {
            let message = try client.message.createTextMessage(text: text)
            let sentMessage = try await client.message.sendMessage(
                message: message,
                recvID: recvID,
                groupID: groupID
            )
            log("Message sent [\(sentMessage.clientMsgID ?? "")]: \(text)", level: .success)
            if let cid = activeConversationID {
                await loadChatMessages(conversationID: cid)
            }
            await fetchConversations()
        } catch {
            errorMessage = "Send message error: \(error.localizedDescription)"
            log("Send message error: \(error)", level: .error)
        }
    }

    public func revokeMessage(conversationID: String, clientMsgID: String) async {
        do {
            try await client.message.revokeMessage(conversationID: conversationID, clientMsgID: clientMsgID)
            log("Revoked message: \(clientMsgID)", level: .info)
            await loadChatMessages(conversationID: conversationID)
        } catch {
            errorMessage = "Revoke error: \(error.localizedDescription)"
            log("Revoke message error: \(error)", level: .error)
        }
    }

    // MARK: - Friend Operations
    public func addFriend(userID: String, reqMsg: String? = "Hello, let's be friends!") async {
        do {
            try await client.friend.addFriend(userID: userID, reqMsg: reqMsg)
            log("Sent friend request to \(userID)", level: .success)
        } catch {
            errorMessage = "Add friend failed: \(error.localizedDescription)"
            log("Add friend error: \(error)", level: .error)
        }
    }

    public func acceptFriendApplication(userID: String, handleMsg: String? = "Agreed") async {
        do {
            try await client.friend.acceptFriendApplication(userID: userID, handleMsg: handleMsg)
            log("Accepted friend request from \(userID)", level: .success)
            await fetchFriendRequests()
            await fetchFriends()
        } catch {
            errorMessage = "Accept friend failed: \(error.localizedDescription)"
            log("Accept friend error: \(error)", level: .error)
        }
    }

    public func refuseFriendApplication(userID: String, handleMsg: String? = "Declined") async {
        do {
            try await client.friend.refuseFriendApplication(userID: userID, handleMsg: handleMsg)
            log("Refused friend request from \(userID)", level: .info)
            await fetchFriendRequests()
        } catch {
            errorMessage = "Refuse friend failed: \(error.localizedDescription)"
            log("Refuse friend error: \(error)", level: .error)
        }
    }

    public func deleteFriend(userID: String) async {
        do {
            try await client.friend.deleteFriend(friendUserID: userID)
            log("Deleted friend \(userID)", level: .info)
            await fetchFriends()
        } catch {
            errorMessage = "Delete friend failed: \(error.localizedDescription)"
            log("Delete friend error: \(error)", level: .error)
        }
    }

    // MARK: - Group Operations
    public func createGroup(name: String, introduction: String? = nil) async {
        do {
            var baseInfo = OpenIMGroupBaseInfo()
            baseInfo.groupName = name
            baseInfo.introduction = introduction
            baseInfo.groupType = .working

            let createInfo = OpenIMGroupCreateInfo(
                groupInfo: baseInfo,
                memberUserIDs: []
            )
            let created = try await client.group.createGroup(createInfo: createInfo)
            log("Created group: \(created.groupName ?? "") [\(created.groupID ?? "")]", level: .success)
            await fetchGroups()
            await fetchConversations()
        } catch {
            errorMessage = "Create group failed: \(error.localizedDescription)"
            log("Create group error: \(error)", level: .error)
        }
    }

    public func quitGroup(groupID: String) async {
        do {
            try await client.group.quitGroup(groupID: groupID)
            log("Left group \(groupID)", level: .info)
            await fetchGroups()
            await fetchConversations()
        } catch {
            errorMessage = "Quit group failed: \(error.localizedDescription)"
            log("Quit group error: \(error)", level: .error)
        }
    }

    // MARK: - OpenIMConversationListener
    public func onSyncServerStart(reinstalled: Bool) {
        log("Conversation sync started (reinstalled: \(reinstalled))", level: .info)
    }

    public func onSyncServerFinish(reinstalled: Bool) {
        log("Conversation sync finished", level: .success)
        Task { @MainActor in
            await self.refreshAll()
        }
    }

    public func onConversationChanged(conversations: [OpenIMConversationInfo]) {
        log("Conversations updated (\(conversations.count) items)", level: .info)
        Task { @MainActor in
            await self.fetchConversations()
        }
    }

    public func onNewConversation(conversations: [OpenIMConversationInfo]) {
        log("New conversation created (\(conversations.count))", level: .info)
        Task { @MainActor in
            await self.fetchConversations()
        }
    }

    public func onTotalUnreadMessageCountChanged(totalUnreadCount: Int) {
        self.totalUnreadCount = totalUnreadCount
        log("Total unread count changed to \(totalUnreadCount)", level: .info)
    }

    // MARK: - OpenIMAdvancedMsgListener
    public func onRecvNewMessage(message: OpenIMMessageInfo) {
        let sender = message.senderNickname ?? message.sendID ?? "Unknown"
        let content = message.textElem?.content ?? "[Media/Custom]"
        log("New message from \(sender): \(content)", level: .info)

        Task { @MainActor in
            if let activeID = self.activeConversationID,
               (message.recvID == activeID || message.sendID == activeID || message.groupID == activeID) {
                await self.loadChatMessages(conversationID: activeID)
            }
            await self.fetchConversations()
        }
    }

    public func onRecvMessageRevoked(revokedInfo: OpenIMMessageRevokedInfo) {
        log("Message revoked: \(revokedInfo.clientMsgID ?? "")", level: .warning)
        Task { @MainActor in
            if let activeID = self.activeConversationID {
                await self.loadChatMessages(conversationID: activeID)
            }
        }
    }

    // MARK: - OpenIMFriendshipListener
    public func onFriendApplicationAdded(friendApplication: OpenIMFriendApplication) {
        log("New friend application from \(friendApplication.fromNickname ?? friendApplication.fromUserID ?? "")", level: .info)
        Task { @MainActor in
            await self.fetchFriendRequests()
        }
    }

    public func onFriendInfoChanged(friendInfo: OpenIMFriendInfo) {
        log("Friend info updated: \(friendInfo.nickname ?? friendInfo.userID ?? "")", level: .info)
        Task { @MainActor in
            await self.fetchFriends()
        }
    }

    // MARK: - OpenIMGroupListener
    public func onJoinedGroupAdded(groupInfo: OpenIMGroupInfo) {
        log("Joined new group: \(groupInfo.groupName ?? groupInfo.groupID ?? "")", level: .info)
        Task { @MainActor in
            await self.fetchGroups()
        }
    }

    public func onJoinedGroupDeleted(groupInfo: OpenIMGroupInfo) {
        log("Removed from group: \(groupInfo.groupName ?? groupInfo.groupID ?? "")", level: .info)
        Task { @MainActor in
            await self.fetchGroups()
        }
    }

    public func onGroupInfoChanged(groupInfo: OpenIMGroupInfo) {
        log("Group info modified: \(groupInfo.groupName ?? groupInfo.groupID ?? "")", level: .info)
        Task { @MainActor in
            await self.fetchGroups()
        }
    }

    // MARK: - OpenIMUserListener
    public func onSelfInfoUpdated(userInfo: OpenIMUserInfo) {
        currentUser = userInfo
        log("Self user profile updated", level: .info)
    }
}
