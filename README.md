
## It is free for commercial use and must be added on the app startup page (powered by OpenIM)
<img src="https://openim-1253691595.cos.ap-nanjing.myqcloud.com/WechatIMG20.jpeg" alt="image" style="width: 200px; " />
# OpenIMSDK

[![Version](https://img.shields.io/cocoapods/v/OpenIMSDK.svg?style=flat)](https://cocoapods.org/pods/OpenIMSDK)
[![License](https://img.shields.io/cocoapods/l/OpenIMSDK.svg?style=flat)](https://cocoapods.org/pods/OpenIMSDK)
[![Platform](https://img.shields.io/cocoapods/p/OpenIMSDK.svg?style=flat)](https://cocoapods.org/pods/OpenIMSDK)

#### [中文文档](https://doc.rentsoft.cn/#/ios_v2/sdk_integrate/development)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Open-IM-SDK-iOS is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'OpenIMSDK'
```

## known issues
```ruby
1: The SDK does not support the amrv7 architecture, pay attention to the settings of Xcode.
```

```ruby
2: Some developers found that using swift to implement the proxy API of sdk was not delivered to the business layer, and needed to be decorated with the @objc symbol.
eg.： @objc public func onFriendApplicationAdded:
```
## License

OpenIMSDK is available under the MIT license. See the LICENSE file for more info.
