//
//  LoginProfileView.swift
//  SwiftExample
//
//  Created for OpenIM iOS SDK Standalone Swift Example.
//

import SwiftUI
import OpenIMSDK

public struct LoginProfileView: View {
    @EnvironmentObject private var service: OpenIMService

    public init() {}

    public var body: some View {
        NavigationView {
            Form {
                if service.isLoggedIn {
                    loggedInSection
                } else {
                    loginFormSection
                }

                serverInfoSection

                aboutSection
            }
            .navigationTitle("Profile & Auth")
            .alert(isPresented: Binding(
                get: { service.errorMessage != nil },
                set: { if !$0 { service.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Notice"),
                    message: Text(service.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // MARK: - Logged In View
    private var loggedInSection: some View {
        Section(header: Text("Current Account")) {
            HStack(spacing: 16) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 60, height: 60)
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)

                    Circle()
                        .fill(service.isConnected ? Color.green : Color.orange)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(service.currentUser?.nickname ?? service.currentUserID)
                        .font(.title3)
                        .bold()

                    Text("ID: \(service.currentUser?.userID ?? service.currentUserID)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    HStack(spacing: 4) {
                        Text("Status:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(service.connectionState)
                            .font(.caption2)
                            .foregroundColor(service.isConnected ? .green : .orange)
                    }
                }
            }
            .padding(.vertical, 8)

            Button {
                Task {
                    await service.refreshAll()
                }
            } label: {
                Label("Sync All Data", systemImage: "arrow.clockwise")
            }

            Button(role: .destructive) {
                Task {
                    await service.logout()
                }
            } label: {
                if service.isBusy {
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Logging out...")
                    }
                } else {
                    Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                }
            }
            .disabled(service.isBusy)
        }
    }

    // MARK: - Login Form
    private var loginFormSection: some View {
        Group {
            Section(header: Text("Quick Switch Account")) {
                HStack(spacing: 12) {
                    Button {
                        service.currentUserID = "6932496926"
                        service.currentToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3OTYyODg0MDQsImlhdCI6MTc4ODUxMjM5OSwiVXNlcklEIjoiNjkzMjQ5NjkyNiIsIlBsYXRmb3JtSUQiOjJ9.G6VU8pqEdkNniUG7XeMcPxsjWPOaxsIuCjEUtvJeF_8"
                    } label: {
                        Text("User A (6932496926)")
                            .font(.caption)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(service.currentUserID == "6932496926" ? Color.blue : Color(.secondarySystemBackground))
                            .foregroundColor(service.currentUserID == "6932496926" ? .white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button {
                        service.currentUserID = "4134683436"
                        service.currentToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3OTY1NDQ4ODUsImlhdCI6MTc4ODc2ODg4MCwiVXNlcklEIjoiNDEzNDY4MzQzNiIsIlBsYXRmb3JtSUQiOjJ9._m55ZRTiR3SvINX5WlwbwoFl8gJPagxz7hweYdt9T8A"
                    } label: {
                        Text("User B (4134683436)")
                            .font(.caption)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(service.currentUserID == "4134683436" ? Color.blue : Color(.secondarySystemBackground))
                            .foregroundColor(service.currentUserID == "4134683436" ? .white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.vertical, 4)
            }

            Section(header: Text("OpenIM Credentials")) {
            TextField("API Address", text: $service.apiAddr)
                .keyboardType(.URL)
                .autocapitalization(.none)

            TextField("WebSocket Gateway", text: $service.wsAddr)
                .keyboardType(.URL)
                .autocapitalization(.none)

            TextField("User ID", text: $service.currentUserID)
                .autocapitalization(.none)

            VStack(alignment: .leading, spacing: 4) {
                Text("User Token")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextEditor(text: $service.currentToken)
                    .frame(height: 80)
                    .font(.system(size: 11, design: .monospaced))
            }

            Button {
                Task {
                    await service.login()
                }
            } label: {
                HStack {
                    Spacer()
                    if service.isBusy {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.trailing, 8)
                        Text("Connecting...")
                    } else {
                        Image(systemName: "bolt.fill")
                        Text("Async Login")
                    }
                    Spacer()
                }
                .font(.headline)
            }
            .disabled(service.isBusy)
        }
    }
    }

    private var serverInfoSection: some View {
        Section(header: Text("Gateway Status")) {
            HStack {
                Text("Connection")
                Spacer()
                Text(service.connectionState)
                    .foregroundColor(service.isConnected ? .green : .secondary)
            }

            HStack {
                Text("Total Unread")
                Spacer()
                Text("\(service.totalUnreadCount)")
                    .foregroundColor(.secondary)
            }
        }
    }

    private var aboutSection: some View {
        Section(header: Text("About")) {
            HStack {
                Text("SDK Version")
                Spacer()
                Text("3.8.3 (Swift Native)")
                    .foregroundColor(.secondary)
            }

            HStack {
                Text("Architecture")
                Spacer()
                Text("Swift Concurrency (async/await)")
                    .foregroundColor(.secondary)
            }
        }
    }
}
