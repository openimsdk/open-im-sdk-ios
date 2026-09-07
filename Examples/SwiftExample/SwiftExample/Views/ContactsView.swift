//
//  ContactsView.swift
//  SwiftExample
//
//  Created for OpenIM iOS SDK Standalone Swift Example.
//

import SwiftUI
import OpenIMSDK

public struct ContactsView: View {
    @EnvironmentObject private var service: OpenIMService
    @State private var selectedSegment: ContactSegment = .friends
    @State private var showingAddFriendSheet: Bool = false
    @State private var showingCreateGroupSheet: Bool = false

    @State private var newFriendUserID: String = ""
    @State private var newFriendReqMsg: String = "Hi, please add me!"
    @State private var newGroupName: String = ""
    @State private var newGroupIntro: String = ""

    public enum ContactSegment: String, CaseIterable, Identifiable {
        case friends = "Friends"
        case groups = "Groups"
        case requests = "Requests"

        public var id: String { rawValue }
    }

    public init() {}

    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Contacts", selection: $selectedSegment) {
                    Text("Friends (\(service.friends.count))").tag(ContactSegment.friends)
                    Text("Groups (\(service.groups.count))").tag(ContactSegment.groups)
                    Text("Requests (\(service.friendRequests.count))").tag(ContactSegment.requests)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.vertical, 8)

                Divider()

                if !service.isLoggedIn {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.system(size: 64))
                            .foregroundColor(.secondary)
                        Text("Sign In Required")
                            .font(.headline)
                        Text("Sign in on the Profile tab to view contacts and groups.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    switch selectedSegment {
                    case .friends:
                        friendsListView
                    case .groups:
                        groupsListView
                    case .requests:
                        requestsListView
                    }
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if service.isLoggedIn {
                        if selectedSegment == .friends {
                            Button {
                                showingAddFriendSheet = true
                            } label: {
                                Image(systemName: "person.badge.plus")
                            }
                        } else if selectedSegment == .groups {
                            Button {
                                showingCreateGroupSheet = true
                            } label: {
                                Image(systemName: "plus.bubble")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddFriendSheet) {
                NavigationView {
                    Form {
                        Section(header: Text("Add Friend")) {
                            TextField("User ID", text: $newFriendUserID)
                                .autocapitalization(.none)
                            TextField("Greeting Message", text: $newFriendReqMsg)

                            Button("Send Friend Request") {
                                showingAddFriendSheet = false
                                Task {
                                    await service.addFriend(userID: newFriendUserID, reqMsg: newFriendReqMsg)
                                    newFriendUserID = ""
                                }
                            }
                            .disabled(newFriendUserID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                    .navigationTitle("Add Friend")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingAddFriendSheet = false }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCreateGroupSheet) {
                NavigationView {
                    Form {
                        Section(header: Text("New Group Details")) {
                            TextField("Group Name", text: $newGroupName)
                            TextField("Introduction (Optional)", text: $newGroupIntro)

                            Button("Create Group") {
                                showingCreateGroupSheet = false
                                Task {
                                    await service.createGroup(name: newGroupName, introduction: newGroupIntro.isEmpty ? nil : newGroupIntro)
                                    newGroupName = ""
                                    newGroupIntro = ""
                                }
                            }
                            .disabled(newGroupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                    .navigationTitle("Create Group")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingCreateGroupSheet = false }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Friends Subview
    private var friendsListView: some View {
        Group {
            if service.friends.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "person.2.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No Friends Added")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                List {
                    ForEach(service.friends, id: \.userID) { friend in
                        HStack(spacing: 12) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(friend.nickname ?? friend.userID ?? "-")
                                    .font(.headline)
                                Text("ID: \(friend.userID ?? "")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                if let uid = friend.userID {
                                    Task {
                                        await service.deleteFriend(userID: uid)
                                    }
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    await service.fetchFriends()
                }
            }
        }
    }

    // MARK: - Groups Subview
    private var groupsListView: some View {
        Group {
            if service.groups.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "person.3")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No Groups Joined")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                List {
                    ForEach(service.groups, id: \.groupID) { group in
                        HStack(spacing: 12) {
                            Image(systemName: "person.3.sequence.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.purple)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(group.groupName ?? group.groupID ?? "Group")
                                    .font(.headline)
                                Text("ID: \(group.groupID ?? "") • \(group.memberCount ?? 0) members")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                if let gid = group.groupID {
                                    Task {
                                        await service.quitGroup(groupID: gid)
                                    }
                                }
                            } label: {
                                Label("Quit", systemImage: "rectangle.portrait.and.arrow.right")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    await service.fetchGroups()
                }
            }
        }
    }

    // MARK: - Requests Subview
    private var requestsListView: some View {
        Group {
            if service.friendRequests.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "tray")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No Pending Friend Requests")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                List {
                    ForEach(service.friendRequests, id: \.fromUserID) { req in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(req.fromNickname ?? req.fromUserID ?? "-")
                                    .font(.headline)
                                Spacer()
                                Text("ID: \(req.fromUserID ?? "")")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }

                            if let msg = req.reqMsg, !msg.isEmpty {
                                Text("\"\(msg)\"")
                                    .font(.subheadline)
                                    .italic()
                                    .foregroundColor(.secondary)
                            }

                            HStack(spacing: 12) {
                                Button {
                                    if let uid = req.fromUserID {
                                        Task {
                                            await service.acceptFriendApplication(userID: uid)
                                        }
                                    }
                                } label: {
                                    Text("Accept")
                                        .font(.caption)
                                        .bold()
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }

                                Button {
                                    if let uid = req.fromUserID {
                                        Task {
                                            await service.refuseFriendApplication(userID: uid)
                                        }
                                    }
                                } label: {
                                    Text("Decline")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .overlay(Capsule().stroke(Color.red, lineWidth: 1))
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    await service.fetchFriendRequests()
                }
            }
        }
    }
}
