//
//  ChatView.swift
//  SwiftExample
//
//  Created for OpenIM iOS SDK Standalone Swift Example.
//

import SwiftUI
import OpenIMSDK

public struct ChatView: View {
    public let conversation: OpenIMConversationInfo
    @EnvironmentObject private var service: OpenIMService
    @State private var inputText: String = ""
    @FocusState private var isInputFocused: Bool

    public init(conversation: OpenIMConversationInfo) {
        self.conversation = conversation
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Message Timeline
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(service.activeChatMessages, id: \.clientMsgID) { msg in
                            MessageBubble(
                                message: msg,
                                isCurrentUser: msg.sendID == service.currentUserID
                            ) {
                                if let cid = conversation.conversationID, let mid = msg.clientMsgID {
                                    Task {
                                        await service.revokeMessage(conversationID: cid, clientMsgID: mid)
                                    }
                                }
                            }
                            .id(msg.clientMsgID)
                        }
                    }
                    .padding()
                }
                .onChange(of: service.activeChatMessages.count) { _ in
                    if let lastID = service.activeChatMessages.last?.clientMsgID {
                        withAnimation {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            // Input Bar
            HStack(spacing: 12) {
                TextField("Type a message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isInputFocused)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18))
                        .foregroundColor(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
        }
        .navigationTitle(conversation.showName ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let cid = conversation.conversationID {
                await service.loadChatMessages(conversationID: cid)
            }
        }
        .onDisappear {
            service.activeConversationID = nil
        }
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""

        let recvID = conversation.conversationType == .c2c ? conversation.userID : nil
        let groupID = (conversation.conversationType == .group || conversation.conversationType == .superGroup) ? conversation.groupID : nil

        Task {
            await service.sendTextMessage(text: text, recvID: recvID, groupID: groupID)
        }
    }
}

public struct MessageBubble: View {
    public let message: OpenIMMessageInfo
    public let isCurrentUser: Bool
    public let onRevoke: () -> Void

    public var body: some View {
        HStack {
            if isCurrentUser { Spacer(minLength: 40) }

            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isCurrentUser, let nickname = message.senderNickname {
                    Text(nickname)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Text(contentString)
                    .font(.body)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isCurrentUser ? Color.blue : Color(.secondarySystemBackground))
                    .foregroundColor(isCurrentUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .contextMenu {
                        if isCurrentUser && message.status != .sendFailure {
                            Button(role: .destructive, action: onRevoke) {
                                Label("Revoke Message", systemImage: "arrow.uturn.backward")
                            }
                        }
                    }

                HStack(spacing: 4) {
                    if let sendTime = message.sendTime {
                        Text(formatTimestamp(sendTime))
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }

                    if isCurrentUser {
                        statusIcon
                    }
                }
            }

            if !isCurrentUser { Spacer(minLength: 40) }
        }
    }

    private var contentString: String {
        if let content = message.textElem?.content {
            return content
        }
        if message.contentType == .image {
            return "[Picture]"
        }
        if message.contentType == .audio {
            return "[Voice]"
        }
        if message.contentType == .video {
            return "[Video]"
        }
        if message.contentType == .file {
            return "[File]"
        }
        return "[Message]"
    }

    @ViewBuilder
    private var statusIcon: some View {
        switch message.status {
        case .sending:
            Image(systemName: "clock")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        case .sendSuccess:
            Image(systemName: "checkmark")
                .font(.system(size: 10))
                .foregroundColor(.blue)
        case .sendFailure:
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 10))
                .foregroundColor(.red)
        default:
            EmptyView()
        }
    }

    private func formatTimestamp(_ timestampMs: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestampMs) / 1000.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
