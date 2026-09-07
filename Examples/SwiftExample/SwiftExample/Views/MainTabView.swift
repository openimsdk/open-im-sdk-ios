//
//  MainTabView.swift
//  SwiftExample
//
//  Created for OpenIM iOS SDK Standalone Swift Example.
//

import SwiftUI

public struct MainTabView: View {
    @EnvironmentObject private var service: OpenIMService
    @State private var selectedTab: Int = 0

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            ConversationsView()
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }
                .badge(service.totalUnreadCount > 0 ? service.totalUnreadCount : 0)
                .tag(0)

            ContactsView()
                .tabItem {
                    Label("Contacts", systemImage: "person.2.fill")
                }
                .badge(service.friendRequests.count > 0 ? service.friendRequests.count : 0)
                .tag(1)

            LoginProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(2)

            LogsView()
                .tabItem {
                    Label("Logs", systemImage: "terminal.fill")
                }
                .tag(3)
        }
    }
}
