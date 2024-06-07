# iOS Client SDK for OpenIM 👨‍💻💬

Use this SDK to add instant messaging capabilities to your app. By connecting to a self-hosted [OpenIM](https://www.openim.online/) server, you can quickly integrate instant messaging capabilities into your app with just a few lines of code.

The underlying SDK core is implemented in [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core). Using [gomobile](https://github.com/golang/mobile), it can be compiled into an XCFramework for iOS integration. iOS interacts with the [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core) through JSON, and the SDK exposes a re-encapsulated API for easy usage. In terms of data storage, iOS utilizes the SQLite layer provided internally by the [OpenIM SDK Core](https://github.com/openimsdk/openim-sdk-core).


## Documentation 📚

Visit [https://docs.openim.io/](https://docs.openim.io/) for detailed documentation and guides.

For the SDK reference, see [Quick Start guide](https://docs.openim.io/sdks/quickstart/ios).

## Installation 💻

### Adding Dependencies

```ruby
pod 'OpenIMSDK'
```

## Usage 🚀

The following examples demonstrate how to use the SDK. Objective-C is used, providing complete type hints.

### Importing the SDK

```swift
@import OpenIMSDK;
```

### Logging In and Listening for Connection Status

> Note: You need to [Deploy OpenIM Server](https://github.com/openimsdk/open-im-server#rocket-quick-start)  first, the default port of OpenIM Server is 10001, 10002.

```swift
OIMInitConfig *config = [OIMInitConfig new];
config.apiAddr = @"";
config.wsAddr = @"";
config.objectStorage = @"";

BOOL success = [OIMManager.manager initSDKWithConfig:config
                                        onConnecting:^{
    // The SDK is currently connecting to the IM server.
} onConnectFailure:^(NSInteger code, NSString * _Nullable msg) {
    // Callback function for connection failure
    // code: Error code
    // error: Error message
} onConnectSuccess:^{
    // The SDK has successfully connected to the IM server.
} onKickedOffline:^{
    // Kicked offline.
} onUserTokenExpired:^{
    // Token expired while online: In this situation, you need to generate a new token and then call the `login()` function again to log in.
}];
```

To log into the IM server, you need to create an account and obtain a user ID and token. Refer to the [access token documentation](https://doc.rentsoft.cn/restapi/userManagement/userRegister) for details.

### Receiving and Sending Messages 💬

OpenIM makes it easy to send and receive messages. By default, there is no restriction on having a friend relationship to send messages (although you can configure other policies on the server). If you know the user ID of the recipient, you can conveniently send a message to them.

```swift
@import OpenIMSDK;

// Listenfor new messages 📩
[OIMManager.callbacker setAdvancedMsgListenerWithOnRecvMessageRevoked:^(OIMMessageRevokedInfo * _Nullable msgRovoked) {
} onRecvC2CReadReceipt:^(NSArray<OIMReceiptInfo *> * _Nullable msgReceiptList) {
} onRecvGroupReadReceipt:^(NSArray<OIMReceiptInfo *> * _Nullable msgReceiptList) {
} onRecvNewMessage:^(OIMMessageInfo * _Nullable message) {
}];

OIMMessageInfo *testMessage = [OIMMessageInfo createTextMessage:@"Hello!"];

[OIMManager.manager sendMessage:testMessage
                         recvID:@""
                        groupID:@""
                offlinePushInfo:nil
                      onSuccess:^(OIMMessageInfo * _Nullable message) {
            // Please note here that the returned message needs to be replaced with the data source.
            testMessage = message;
} onProgress:^(NSInteger number) {
} onFailure:^(NSInteger code, NSString * _Nullable msg) {
}];
```

## Examples 🌟

You can find a demo app that uses the SDK in the [open-im-ios-demo](https://github.com/openimsdk/open-im-ios-demo) repository.

## Requirements 🌐

+ The minimum deployment target is iOS 11.0.

## Community :busts_in_silhouette:

- 📚 [OpenIM Community](https://github.com/OpenIMSDK/community)
- 💕 [OpenIM Interest Group](https://github.com/Openim-sigs)
- 🚀 [Join our Slack community](https://join.slack.com/t/openimsdk/shared_invite/zt-2ijy1ys1f-O0aEDCr7ExRZ7mwsHAVg9A)
- :eyes: [Join our wechat (微信群)](https://openim-1253691595.cos.ap-nanjing.myqcloud.com/WechatIMG20.jpeg)

## Community Meetings :calendar:

We want anyone to get involved in our community and contributing code, we offer gifts and rewards, and we welcome you to join us every Thursday night.

Our conference is in the [OpenIM Slack](https://join.slack.com/t/openimsdk/shared_invite/zt-22720d66b-o_FvKxMTGXtcnnnHiMqe9Q) 🎯, then you can search the Open-IM-Server pipeline to join

We take notes of each [biweekly meeting](https://github.com/orgs/OpenIMSDK/discussions/categories/meeting) in [GitHub discussions](https://github.com/openimsdk/open-im-server/discussions/categories/meeting), Our historical meeting notes, as well as replays of the meetings are available at [Google Docs :bookmark_tabs:](https://docs.google.com/document/d/1nx8MDpuG74NASx081JcCpxPgDITNTpIIos0DS6Vr9GU/edit?usp=sharing).

## Who are using OpenIM :eyes:

Check out our [user case studies](https://github.com/OpenIMSDK/community/blob/main/ADOPTERS.md) page for a list of the project users. Don't hesitate to leave a [📝comment](https://github.com/openimsdk/open-im-server/issues/379) and share your use case.

## License :page_facing_up:

OpenIM is licensed under the Apache 2.0 license. See [LICENSE](https://github.com/openimsdk/open-im-server/tree/main/LICENSE) for the full license text.
