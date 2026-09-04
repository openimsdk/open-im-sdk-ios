# Swift SDK 重構進度

目前分支 `feature/swift-sdk-rewrite` 已建立新的 Swift-first API 基礎，並以 `OpenIMCoreAdapter` 隔離 gomobile 產生的核心模組。Swift 版本會直接取代舊的 Objective-C wrapper，不提供兩套公開 API 並存。

## 套件分發策略

Swift Package Manager 與 CocoaPods 必須使用同一版本的 `OpenIMCore.xcframework`：

兩種套件管理器都使用相同的 module name，因此呼叫端不需要因為安裝方式不同而改變 import：

```swift
import OpenIMSDK
```

Swift 原始碼中的 `enum`、`struct`、`class` 與 public member name 會直接由兩種套件管理器共用；名稱不應依賴 CocoaPods 的 spec name 或資料夾名稱自動推導。

- SPM 使用 `binaryTarget`，指向 release 上的 `.xcframework.zip` 並鎖定 checksum。
- CocoaPods 使用 `OpenIMSDKCore` pod 提供相同的 XCFramework；`OpenIMSDK.podspec` 是唯一的 CocoaPods spec。
- `MJExtension` 不納入新的 Swift API；模型層將改用 `Codable` 與自訂 decoder。

目前尚未把 80 MB 以上的核心 framework 直接提交到 repository，也尚未有可供 SPM 使用的 release artifact。因此 Swift API 的第一階段在沒有核心模組的環境使用 `UnavailableOpenIMCoreAdapter`，讓 API、狀態機與測試可以獨立建置；透過 CocoaPods 安裝 `OpenIMSDKCore` 時，會自動啟用 `NativeOpenIMCoreAdapter`。

完成 core artifact 發佈後，`Package.swift` 的 target 可改為：

```swift
.binaryTarget(
    name: "OpenIMCore",
    url: "https://github.com/<owner>/<repo>/releases/download/<version>/OpenIMCore.xcframework.zip",
    checksum: "<swift-package-checksum>"
),
.target(
    name: "OpenIMSDK",
    dependencies: ["OpenIMCore"],
    path: "Sources/OpenIMSDK"
)
```

## 驗證

```bash
swift test
pod lib lint OpenIMSDK.podspec --allow-warnings --skip-tests
```

即時 smoke test 僅可透過環境變數明確啟用，帳號資訊不會寫入 repository：

```bash
OPENIM_RUN_INTEGRATION_TESTS=1 \
OPENIM_TEST_USER_ID="$OPENIM_TEST_USER_ID" \
OPENIM_TEST_TOKEN="$OPENIM_TEST_TOKEN" \
OPENIM_TEST_API_ADDR="$OPENIM_TEST_API_ADDR" \
OPENIM_TEST_WS_ADDR="$OPENIM_TEST_WS_ADDR" \
swift test --filter OpenIMIntegrationTests
```
