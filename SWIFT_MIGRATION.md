# Swift SDK 重構進度

目前分支 `feature/swift-sdk-rewrite` 已建立新的 Swift-first API 基礎，並以 `OpenIMCoreAdapter` 隔離 gomobile 產生的核心模組。

## 套件分發策略

Swift Package Manager 與 CocoaPods 必須使用同一版本的 `OpenIMCore.xcframework`：

兩種套件管理器都使用相同的 module name，因此呼叫端不需要因為安裝方式不同而改變 import：

```swift
import OpenIMSDK
```

Swift 原始碼中的 `enum`、`struct`、`class` 與 public member name 會直接由兩種套件管理器共用；名稱不應依賴 CocoaPods 的 spec name 或資料夾名稱自動推導。

- SPM 使用 `binaryTarget`，指向 release 上的 `.xcframework.zip` 並鎖定 checksum。
- CocoaPods 使用 `vendored_frameworks`，或在過渡期間依賴 `OpenIMSDKCore` pod。
- `MJExtension` 不納入新的 Swift API；模型層將改用 `Codable` 與自訂 decoder。

目前尚未把 80 MB 以上的核心 framework 直接提交到 repository，也尚未有可供 SPM 使用的 release artifact。因此 Swift API 的第一階段使用 `UnavailableOpenIMCoreAdapter`，先讓 API、狀態機與測試可以獨立建置。

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
pod lib lint OpenIMSDKSwift.podspec --allow-warnings --skip-tests
```
