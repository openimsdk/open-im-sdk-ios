# iOS Client SDK for OpenIM 👨‍💻💬

The official **Swift-first SDK** for [OpenIM](https://www.openim.online/), redesigned from the ground up for modern iOS development using **Swift Concurrency (`async/await`)**, clean structured data models, and reactive events.

Connect to a self-hosted or cloud OpenIM server to integrate instant messaging into your iOS apps with concise, thread-safe, and idiomatic Swift code.

---

## Features 🚀

- **Pure Swift Concurrency**: All business APIs (`login`, `sendMessage`, `getFriendList`, `createGroup`, `getAllConversationList`, etc.) use native `async/await throws`. No callback hell or nested completion handlers.
- **Strongly Typed Models**: Every parameter, return type, and listener payload is represented as clean Swift structs and enums (`OpenIMUserInfo`, `OpenIMMessageInfo`, `OpenIMConversationInfo`, etc.).
- **UIKit & SwiftUI Ready**: Effortlessly bind to SwiftUI views using `@ObservedObject` or UIKit `UIViewController`.
- **Comprehensive Lifecycle & Listeners**: Type-safe protocols for real-time connection status, conversation updates, message delivery, group events, and user statuses.
- **Backward & Dual Compatibility**: Available via both **CocoaPods** and **Swift Package Manager (SPM)**.

---

## Installation 💻

### CocoaPods

Add OpenIMSDK to your `Podfile`:

```ruby
platform :ios, '13.0'
use_frameworks!

target 'YourApp' do
  pod 'OpenIMSDK'
end
```

Then run:

```bash
pod install
```

### Swift Package Manager (SPM)

In Xcode, select **File > Add Package Dependencies...** and enter the repository URL:

```
https://github.com/OpenIMSDK/Open-IM-SDK-iOS.git
```

---

## Quick Start 🌟

### 1. Import the SDK

```swift
import OpenIMSDK
```

### 2. Initialize the Client

```swift
let client = OpenIMClient()

// Configure local storage and server endpoints
let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
let dataDir = docsDir?.appendingPathComponent("OpenIM_Data")

let config = OpenIMConfiguration(
    apiAddress: "http://your-server-api-address:10002",
    websocketAddress: "ws://your-server-ws-address:10001",
    dataDirectory: dataDir,
    platform: .iPhone,
    logLevel: 5
)

do {
    try client.initialize(configuration: config)
    print("OpenIM SDK initialized successfully!")
} catch {
    print("SDK initialization failed: \(error)")
}
```

### 3. Observe Connection Events

```swift
let observerID = client.observeEvents { event in
    switch event {
    case .connecting:
        print("Connecting to OpenIM gateway...")
    case .connected:
        print("Connected to OpenIM gateway! 🟢")
    case let .connectionFailed(code, msg):
        print("Connection failed with code \(code): \(msg ?? "")")
    case .kickedOffline:
        print("User was kicked offline ⚠️")
    case .tokenExpired:
        print("User token has expired ⚠️")
    case let .tokenInvalid(msg):
        print("User token invalid: \(msg ?? "")")
    }
}
```

### 4. User Login & Logout (`async/await`)

```swift
Task {
    do {
        // Asynchronously log in
        try await client.login(userID: "user123", token: "your_jwt_token")
        print("User logged in successfully!")

        // Fetch personal profile
        let selfInfo = try await client.user.getSelfUserInfo()
        print("Welcome, \(selfInfo.nickname ?? selfInfo.userID ?? "")!")
    } catch {
        print("Login failed: \(error.localizedDescription)")
    }
}

// Logout
Task {
    do {
        try await client.logout()
        print("Logged out")
    } catch {
        print("Logout error: \(error)")
    }
}
```

---

## Messaging Operations 📩

All message operations are available through `client.message`:

```swift
Task {
    do {
        // 1. Create a text message
        let message = try client.message.createTextMessage(text: "Hello from Swift async/await! 🚀")

        // 2. Send message (C2C or Group)
        let sentMessage = try await client.message.sendMessage(
            message: message,
            recvID: "recipient_user_id",
            groupID: nil
        )
        print("Message sent with ID: \(sentMessage.clientMsgID ?? "")")

        // 3. Fetch conversation message history
        let options = OpenIMGetMessageOptions(
            conversationID: "si_recipient_user_id_user123",
            count: 20
        )
        let history = try await client.message.getAdvancedHistoryMessageList(options: options)
        print("Retrieved \(history.messageList?.count ?? 0) history messages.")

        // 4. Revoke a message
        if let msgID = sentMessage.clientMsgID {
            try await client.message.revokeMessage(
                conversationID: "si_recipient_user_id_user123",
                clientMsgID: msgID
            )
            print("Message revoked!")
        }
    } catch {
        print("Messaging error: \(error)")
    }
}
```

---

## Conversations & Friends & Groups 👥

### Conversations

```swift
Task {
    do {
        // Get all conversations sorted by activity
        let conversations = try await client.conversation.getAllConversationList()
        for conv in conversations {
            print("\(conv.showName ?? ""): unread \(conv.unreadCount ?? 0)")
        }

        // Get total unread count across all conversations
        let unreadTotal = try await client.conversation.getTotalUnreadMsgCount()
        print("Total unread count: \(unreadTotal)")

        // Set draft
        try await client.conversation.setConversationDraft(
            conversationID: "si_friend_user_id",
            draftText: "See you tomorrow!"
        )
    } catch {
        print("Conversation error: \(error)")
    }
}
```

### Friend Management

```swift
Task {
    do {
        // Send a friend request
        try await client.friend.addFriend(userID: "friend_uid", reqMsg: "Hi, let's connect!")

        // Fetch friend list
        let friends = try await client.friend.getFriendList()
        print("Friends count: \(friends.count)")

        // Accept a friend request
        try await client.friend.acceptFriendApplication(userID: "requester_uid", handleMsg: "Accepted!")
    } catch {
        print("Friendship error: \(error)")
    }
}
```

### Group Management

```swift
Task {
    do {
        // Create a working group
        var baseInfo = OpenIMGroupBaseInfo()
        baseInfo.groupName = "Swift Developers"
        baseInfo.groupType = .working

        let createInfo = OpenIMGroupCreateInfo(groupInfo: baseInfo, memberUserIDs: ["userA", "userB"])
        let group = try await client.group.createGroup(createInfo: createInfo)
        print("Group created with ID: \(group.groupID ?? "")")

        // Fetch members
        if let gid = group.groupID {
            let members = try await client.group.getGroupMemberList(groupID: gid, filter: .all, offset: 0, count: 50)
            print("Group has \(members.count) members.")
        }
    } catch {
        print("Group error: \(error)")
    }
}
```

---

## Real-Time Event Listeners 🔔

Conform to strongly typed listener protocols to receive real-time updates:

```swift
class MyIMManager: OpenIMAdvancedMsgListener, OpenIMConversationListener {
    let client = OpenIMClient()

    func setup() {
        client.setAdvancedMsgListener(self)
        client.setConversationListener(self)
    }

    // New message received
    func onRecvNewMessage(message: OpenIMMessageInfo) {
        print("Received message: \(message.textElem?.content ?? "") from \(message.sendID ?? "")")
    }

    // Message revoked
    func onRecvMessageRevoked(revokedInfo: OpenIMMessageRevokedInfo) {
        print("Message revoked: \(revokedInfo.clientMsgID ?? "")")
    }

    // Conversations updated
    func onConversationChanged(conversations: [OpenIMConversationInfo]) {
        print("Conversations updated: \(conversations.count)")
    }

    func onTotalUnreadMessageCountChanged(totalUnreadCount: Int) {
        print("Total unread count changed to \(totalUnreadCount)")
    }
}
```

---

## Example Apps 📱

### 1. Modern Standalone Swift Example (`Examples/SwiftExample`) ⭐ Recommended
A 100% pure Swift, modern SwiftUI example showcasing **Swift Concurrency (`async/await`)** and MVVM architecture:

- **Chats & Messaging (`ConversationsView.swift`, `ChatView.swift`)**:
  - Live conversation list with unread counter badges and last message preview.
  - Swipe actions to pin/unpin, mark as read, or delete conversations.
  - Interactive chat timeline with message bubbles (outgoing/incoming), delivery status indicators, and long-press context menu to **revoke messages**.
  - Send messages via `client.message.sendMessage(message:recvID:groupID:)` using `async/await`.
- **Contacts & Groups (`ContactsView.swift`)**:
  - Friends list with add friend dialog and delete friend action.
  - Joined groups list with create group modal and quit group action.
  - Friend requests tab with instant **Accept** / **Decline** actions.
- **Authentication & Profile (`LoginProfileView.swift`)**:
  - Preconfigured test server endpoints and credentials.
  - Live connection status badge (`Connected`, `Connecting...`, `Token Expired`, etc.).
  - User profile card and one-tap "Sync All Data".
- **Real-time Event Logs (`LogsView.swift`)**:
  - Live stream of all SDK listener events (`OpenIMCoreEvent`, `OpenIMConversationListener`, `OpenIMAdvancedMsgListener`, `OpenIMFriendshipListener`, `OpenIMGroupListener`).
  - Real-time search and filter capabilities with level badges (`[OK]`, `[INFO]`, `[WARN]`, `[ERR]`).

#### Running the Swift Example
```bash
cd Examples/SwiftExample
pod install
open SwiftExample.xcworkspace
```
Select the **`SwiftExample`** scheme and run on any iOS Simulator or device (iOS 15.0+).

---

### 2. Legacy Objective-C Example (`Examples/OCExample`)
The original Objective-C test suite and example project is preserved in `Examples/OCExample` for legacy compatibility and reference:
```bash
cd Examples/OCExample
pod install
open OpenIMSDKiOS.xcworkspace
```

---

## Requirements 🌐

- iOS 13.0+
- Xcode 15.0+
- Swift 5.9+

---

## License :page_facing_up:

This software is licensed under a dual-license model:
- The GNU Affero General Public License (AGPL), Version 3 or later; **OR**
- Commercial license terms from OpenIMSDK.

For commercial licensing, contact: [contact@openim.io](mailto:contact@openim.io)
Website: [https://www.openim.io](https://www.openim.io)
