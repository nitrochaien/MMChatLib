[![Swift](https://img.shields.io/badge/Swift-5-orange?style=flat-square)](https://img.shields.io/badge/Swift-5-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS_macOS-Green?style=flat-square)
[![Version](https://img.shields.io/badge/iOS-13+-blue?style=flat-square)](https://img.shields.io/badge/iOS-13+)

MMChatLib is a Mattermost custom chat framework written in Swift

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Actions](#actions)

## Features
- [x] Connect to Mattermost Websocket
- [x] Create direct channel to chat
- [x] Send message with text and files
- [x] Edit / Delete a message
- [x] Notify when peer is typing
- [x] Chat history
- [x] Get unread messages count
- [x] Get list of reactions for a message
- [x] Remove reaction from a message

## Installation
### Import framework
- Download `MMChatLib.xcframework`
- Drag and drop `xcframework` to your project (copy if needed)
- Add  `Import paths`
    - Select project
    - Choose `Target` > `Build Settings`
    - Search `Import paths`
    - Add the following paths
    ``` ruby
    $(PROJECT_DIR)/<Project name>/MMChatLib.xcframework/ios-arm64
    $(PROJECT_DIR)/<Project name>/MMChatLib.xcframework/ios-x86_64-simulator
    ```
- Build project
### Cocoapods
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate MMChatLib into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'MMChatLib', :git => 'https://git.grooo.vn/mattermost/ioschatlib.git'
```
## Usage
``` swift
import MMChatLib
```
Create global MMSession variable
``` swift
var session: MMSession!
```
Create session
> Domain does not contain `https://`, `wss://` or `path`
``` swift
session = .init(token: userToken, userId: userId, domain: domain)
```
Use `MMSessionDelegate` to track session events
``` swift
// Set delgate
session.delegate = self

// Functions of MMSessionDelegate
func mmSession(_ session: MMSession, didOccurError error: Error) {
    print("Error:", error.localizedDescription)
}

func mmSession(_ session: MMSession, didCreateChannel id: String) {
    print("Channel created! Id:", id)
}

func mmSession(_ session: MMSession, onEvent event: MMSocketEvent) {
    switch event.event {
        case .posted:
            if let messageEvent = event.response as? MessageEvent {
                print("Received:", messageEvent.message ?? "null")
            }
        // Handle more events here
        default:
            print("Event not found.")
    }
}
```
End session when finish
``` swift
session.terminate()
```
## Actions
### Channels
Create a direct channel to chat between 2 users
``` swift
session.start(between: [userId1, userId2]])
```
Get chat history
``` swift
session.getMessages(page: currentPage, perPage: limit) { messages in
    // Handle messages
}
```
### Posts
Send plain text
``` swift
session.send(message)
```
Send message with images. MMSession returns index of uploaded images and progresses while uploading. Then, return `completion` when all images are uploaded.
``` swift
session.send(messageText, imagesData: imageDatas) { index, progress in
    switch index {
        // Handle index here
    }
} completion: {
    print("Done!!!")
}
```
Update a post
``` swift
session.editMessage(postId, message: message) { post in
    // Handle new post
}
```
Delete a post
``` swift
session.deleteMessage(postId) {
    // Handle after delete. Only return if success.
}
```
### Users
Send typing action to peer
``` swift
session.sendTypingNoti()
```
Get unread message count
``` swift
session.getUnreadCount(of: userId) { count in
    // Handle count
}
```
### Reactions
Get reaction list of a post
``` swift
session.getReactionList(postId) { reactionList in
    // Handle list
}
```
Remove reaction from a post
``` swift
session.removeReaction(postId, emojiName: emojiName) {
    // Handle after delete. Only return if success.
}
