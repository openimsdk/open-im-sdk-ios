//
//  ConversationsView.swift
//  SwiftExample
//
//  Created for OpenIM iOS SDK Standalone Swift Example.
//

import SwiftUI
import OpenIMSDK

public struct ConversationsView: View {
    @EnvironmentObject private var service: OpenIMService
    @State private var searchText: String = ""
    @State private var showingNewChatSheet: Bool = false
    @State private var targetUserID: String = ""

    public init() {}

    private var filteredConversations: [OpenIMConversationInfo] {
        if searchText.isEmpty {
            return service.conversations
        }
        return service.conversations.filter { conv in
            (conv.showName?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            (conv.latestMsg?.textElem?.content?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    public var body: some View {
        NavigationView {
            Group {
                if !service.isLoggedIn {
                    VStack(spacing: 16) {
                        Image(systemName: "lock.circle")
                            .font(.system(size: 64))
                            .foregroundColor(.secondary)
                        Text("Not Logged In")
                            .font(.title2)
                            .bold()
                        Text("Please navigate to the Profile tab to log into your OpenIM account.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                } else if service.conversations.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 64))
                            .foregroundColor(.secondary)
                        Text("No Conversations Yet")
                            .font(.title3)
                            .bold()
                        Text("Start a conversation by tapping the + button in the navigation bar.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                } else {
                    List {
                        ForEach(filteredConversations, id: \.conversationID) { conv in
                            NavigationLink(destination: ChatView(conversation: conv)) {
                                ConversationRow(conversation: conv)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    if let cid = conv.conversationID {
                                        Task {
                                            await service.pinConversation(
                                                conversationID: cid,
                                                isPinned: !(conv.isPinned ?? false)
                                            )
                                        }
                                    }
                                } label: {
                                    Label(
                                        (conv.isPinned ?? false) ? "Unpin" : "Pin",
                                        systemImage: (conv.isPinned ?? false) ? "pin.slash.fill" : "pin.fill"
                                    )
                                }
                                .tint(.orange)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    if let cid = conv.conversationID {
                                        Task {
                                            await service.deleteConversation(conversationID: cid)
                                        }
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }

                                if (conv.unreadCount ?? 0) > 0 {
                                    Button {
                                        if let cid = conv.conversationID {
                                            Task {
                                                await service.markConversationAsRead(conversationID: cid)
                                            }
                                        }
                                    } label: {
                                        Label("Read", systemImage: "envelope.open.fill")
                                    }
                                    .tint(.blue)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .refreshable {
                        await service.fetchConversations()
                    }
                }
            }
            .navigationTitle("Chats")
            .searchable(text: $searchText, prompt: "Search chats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewChatSheet = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .disabled(!service.isLoggedIn)
                }
            }
            .sheet(isPresented: $showingNewChatSheet) {
                NavigationView {
                    Form {
                        Section(header: Text("Start Direct Chat")) {
                            TextField("Enter User ID", text: $targetUserID)
                                .autocapitalization(.none)

                            Button("Create & Send Message") {
                                showingNewChatSheet = false
                                Task {
                                    await service.sendTextMessage(
                                        text: "Hi!",
                                        recvID: targetUserID,
                                        groupID: nil
                                    )
                                    targetUserID = ""
                                }
                            }
                            .disabled(targetUserID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                    .navigationTitle("New Chat")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingNewChatSheet = false
                            }
                        }
                    }
                }
            }
        }
    }
}

public struct ConversationRow: View {
    public let conversation: OpenIMConversationInfo

    public var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(conversation.conversationType == .c2c ? Color.blue.opacity(0.15) : Color.purple.opacity(0.15))
                    .frame(width: 48, height: 48)

                Image(systemName: conversation.conversationType == .c2c ? "person.fill" : "person.3.fill")
                    .foregroundColor(conversation.conversationType == .c2c ? .blue : .purple)
                    .font(.system(size: 20))
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.showName ?? conversation.conversationID ?? "Chat")
                        .font(.headline)
                        .lineLimit(1)

                    if conversation.isPinned == true {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                    }

                    Spacer()

                    if let sendTime = conversation.latestMsgSendTime {
                        Text(formatTime(sendTime))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                HStack {
                    Text(latestMessagePreview)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    Spacer()

                    if let unread = conversation.unreadCount, unread > 0 {
                        Text("\(unread)")
                            .font(.caption2)
                            .bold()
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var latestMessagePreview: String {
        guard let msg = conversation.latestMsg else {
            return "No messages yet"
        }
        if let text = msg.textElem?.content {
            return text
        }
        if msg.contentType == .image {
            return "[Photo]"
        }
        if msg.contentType == .audio {
            return "[Audio]"
        }
        if msg.contentType == .video {
            return "[Video]"
        }
        return "[Message]"
    }

    private func formatTime(_ timestampMs: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestampMs) / 1000.0)
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd"
            return formatter.string(from: date)
        }
    }
}
