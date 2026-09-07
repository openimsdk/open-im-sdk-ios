# Swift SDK 重構與整合指南

分支 `feature/swift-sdk-rewrite` 已實現完整的 Swift-first OpenIM iOS SDK，並確保同時相容 **CocoaPods** 與 **Swift Package Manager (SPM)**。

## 一、 套件分發與相容策略

1. **統一模組名稱**：
   無論是透過 CocoaPods 還是 SPM 安裝，呼叫端均使用相同的 import：
   ```swift
   import OpenIMSDK
   ```
2. **CocoaPods**：
   - `OpenIMSDK.podspec` 相依於 `OpenIMSDKCore`（`3.8.3-hotfix.14`），引入 gomobile 產生的 `OpenIMCore.xcframework`。
   - 編譯時自動啟用 `NativeOpenIMCoreAdapter`，連結底層 C/Go 函式與事件回調。
3. **Swift Package Manager (SPM)**：
   - `Package.swift` 預設直接編譯 `Sources/OpenIMSDK`。
   - 透過 `#if canImport(OpenIMCore)` 隔離架構，在無二進位包環境下可使用 `UnavailableOpenIMCoreAdapter` 進行輕量化單元測試；當加入 `OpenIMCore.xcframework` binary target 或整合 CocoaPods 時，自動切換為 `NativeOpenIMCoreAdapter`。

## 二、 SDK 架構與模組設計

SDK 採用 Swift 6 現代並發標準，所有實體模型皆遵循 `Codable`、`Sendable` 與 `Equatable`，全面移除 `MJExtension`。

### 1. 核心實體 (`OpenIMClient`)
- **生命週期管理**：`initialize`, `login`, `logout`, `uninitialize`。
- **子模組入口**：
  - `client.user`: 個人資料與在線狀態管理 ([`OpenIMUserManager`](file:///Volumes/T7/Dev/Native/sdk/open-im-sdk-ios/Sources/OpenIMSDK/Manager/UserManager.swift))
  - `client.friend`: 好友、好友申請與黑名單管理 ([`OpenIMFriendManager`](file:///Volumes/T7/Dev/Native/sdk/open-im-sdk-ios/Sources/OpenIMSDK/Manager/FriendManager.swift))
  - `client.group`: 群組創建、成員管理與加群審批 ([`OpenIMGroupManager`](file:///Volumes/T7/Dev/Native/sdk/open-im-sdk-ios/Sources/OpenIMSDK/Manager/GroupManager.swift))
  - `client.conversation`: 會話列表、置頂、草稿與免打擾 ([`OpenIMConversationManager`](file:///Volumes/T7/Dev/Native/sdk/open-im-sdk-ios/Sources/OpenIMSDK/Manager/ConversationManager.swift))
  - `client.message`: 消息創建、發送、進度回調、歷史查詢與撤回 ([`OpenIMMessageManager`](file:///Volumes/T7/Dev/Native/sdk/open-im-sdk-ios/Sources/OpenIMSDK/Manager/MessageManager.swift))

### 2. API 風格（同時支援 Async/Await 與 Completion Handler）

#### 使用 Async/Await (iOS 13+)：
```swift
let client = OpenIMClient()

// 初始化與登入
try client.initialize(configuration: OpenIMConfiguration(
    apiAddress: "https://api.example.com",
    websocketAddress: "wss://ws.example.com"
))
try await client.login(userID: "user01", token: "token_abc")

// 獲取個人資訊
let selfInfo = try await client.user.getSelfUserInfo()
print("Hello, \(selfInfo.nickname ?? "")")

// 發送文字消息
let message = try client.message.createTextMessage(text: "Hello from Swift SDK!")
let sentMessage = try await client.message.sendMessage(message: message, recvID: "user02")
```

#### 使用 Callback (相容舊專案風格)：
```swift
client.user.getSelfUserInfo { result in
    switch result {
    case .success(let userInfo):
        print("User: \(userInfo.nickname ?? "")")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

### 3. 事件監聽 (Listeners)
提供 5 大監聽協定：
- `OpenIMUserListener`：個人資料、在線狀態變更。
- `OpenIMFriendshipListener`：好友新增/刪除、申請與黑名單變更。
- `OpenIMGroupListener`：加群/退群、成員異動、禁言狀態變更。
- `OpenIMConversationListener`：會話變更、新會話、未讀總數異動、同步進度。
- `OpenIMAdvancedMsgListener`：收到新消息、已讀回執、消息撤回。

```swift
client.setConversationListener(self)
client.setAdvancedMsgListener(self)
```

## 三、 本地與 CI 驗證

```bash
# 1. 執行 SwiftPM 單元測試（含 ModelTests, OpenIMClientTests, ManagerTests）
swift test

# 2. 驗證 CocoaPods 依賴與編譯（連結 OpenIMSDKCore.xcframework）
pod lib lint OpenIMSDK.podspec --allow-warnings --skip-tests
```
