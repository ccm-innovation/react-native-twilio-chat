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

- [AccessManager](#accessmanager)
- Client
- Channel
- Message
- UserInfo

### AccessManager
The AccessManager is Twilio's separation of authenticating your instance of Twilio from the functionality of IP Messaging.

#### `var accessManager = new AccessManager(token)`
|Name |Type |Description |
|--- |--- |--- |
|`token`|String|The access token provided by your server

#### Properties
|Name |Type |Description |
|--- |--- |--- |
|`identity`|String|The identity (username) of your access manager
|`token`|String|The current token
|`isExpired`|Boolean|Whether or not the token has expired
|`expires`|Date|The timestamp of when the token will expire

#### Methods

##### `updateToken(newToken)`
|Name |Type |Description |
|--- |--- |--- |
|`newToken`|String|A new token to renew your instance with

#### Events
You can specify handlers for events on the `accessManager` instance itself. For example, if you wanted to listen to the token expiration event, you would set `accessManager.onTokenExpired = function() { console.log('Token expired') }`.

##### onTokenExpired
Fired when the current token expires
##### onTokenError
Generic error handler for Access Manager issues. Returns the error and objective-c userInfo attributes.

|Name |Type |Description |
|--- |--- |--- |
|`error`|String|The error message from the SDK
|`userInfo`|Object|The contents of the userInfo method of the Error
