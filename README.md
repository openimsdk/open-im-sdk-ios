
## 可以免费商用，必须在app启动页加上 (由OpenIM提供技术支持)
![avatar](https://github.com/OpenIMSDK/OpenIM-Docs/blob/main/docs/images/WechatIMG20.jpeg)
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

## 已知的几个问题
```ruby
问题1: The 'Pods-xxx' target has transitive dependencies that include statically linked binaries: (xxx/Pods/OpenIMSDKCore/Framework/OpenIMCore.xcframework)

处理Podfile内容（a、b选择其一， 升级2.0.7.4不需要处理）:
  a. 删除
      use_frameworks!
  b. 增加 
      pre_install do |installer|
        Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
      end
```

```ruby
问题2: SDK 不支持amrv7架构，注意Xcode的设置。
```

```ruby
问题3: 升级2.0.7.4后恢复问题1的原有内容。
```

```ruby
问题4: 有开发者发现使用swift实现sdk的代理API未传递到业务层，需要使用@objc符号修饰。
例如： @objc public func onFriendApplicationAdded:
```
## License

OpenIMSDK is available under the MIT license. See the LICENSE file for more info.
