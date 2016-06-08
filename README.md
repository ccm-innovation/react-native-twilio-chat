# React Native Twilio IP Messaging
>React Native wrapper for the Twilio IP Messaging SDKs

## Installation
```npm install --save react-native-twilio-ip-messaging```

### iOS
1. Install Twilio IP Messaging SDK via CocoaPods.

    ```
    source 'https://github.com/twilio/cocoapod-specs'
    pod 'TwilioIPMessagingClient', '~> 0.14.1'
    ```
 2. Add `RCTTwilioIPMessaging.xcxcodeproj` to your Project's Libraries (located in `./node_modules/react-native-twilio-ip-messaging/`).
 3. Drag `libRCTTwilioIPMessaging.a` from the Products group to your targets `Build Phases` -> `Link Binary With Libraries` phase.

## Documentation

### Classes

- AccessManager
- Client
- Channel
- Message
- UserInfo
