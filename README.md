# EEChat: OpenIM Messaging Client for iOS

iOS client for [OpenIM](https://github.com/OpenIMSDK/Open-IM-Server) in Swift.

Status: beta. Usable and mostly stable but bugs may happen.



## Features

### Completed

* Login
* Register new accounts.
* Start new chats.
* Edit personal details.
* Edit chat parameters.
* View the list of active chats
* Send and receive plain text messages one-on-one or in group chats.
* In-app presence notifications.
* Unread message counters.
* Local data persistence.
* Transport Level Security - https/wss.
* Viewing attachments and inline images.
* Delivery and received/read indicators for messages (little check marks in messages).
* Muting/un-muting conversations and other permission management.
* Push notifications.
* Attachments and inline images.

### Not Done Yet

* Group chats.

* Previews not generated for videos, audio, links or docs.
* Typing indicators.
* No support for switching between multiple backends.
* Mentions, hashtags.
* Replying or forwarding messages.
* End-to-End encryption.



## Screenshots

<img src="Images/1.jpeg" alt="App screenshot - chat list" width="207" /><img src="Images/2.jpeg" alt="App screenshot - conversation" width="207" /><img src="Images/3.jpeg" alt="App screenshot - account settings" width="207" />



## Installation

### [CocoaPods](https://cocoapods.org/) **Recommended**

```ruby
# Swift 5.3
pod 'OpenIM', git: "https://github.com/OpenIMSDK/Open-IM-SDK-iOS.git" #, :commit => ''
pod 'OpenIMUI', git: "https://github.com/OpenIMSDK/Open-IM-SDK-iOS.git" #, :commit => ''
```


## Requirements

- **iOS 11** or later
- **Swift 5.3** or later


## OpenIM

### Login

```swift
class OIMManager.login(uid:token:callback:)
```



### Create a message 
```swift
class OIMManager.createTextMessage(_:at:)
class OIMManager.createImageMessage(_:)
class OIMManager.createSoundMessage(_:duration:)
class OIMManager.createVideoMessage(_:videoType:duration:snapshotPath:)
```

### Send a message 

```swift
class OIMManager.sendMessage(_:receiver:groupID:onlineUserOnly:progress:callback:)
```



