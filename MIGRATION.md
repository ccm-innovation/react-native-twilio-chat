# Migration from IP Messaging

This new package contains breaking changes from it's predecessor, react-native-twilio-ip-messaging, mainly due the nature of how Twilio updated their SDKs with the product change from IP Messaging to Programmable Chat.

I believe this is complete -- but if you come across any issues please let us know so we can update!

### Installation

#### iOS
 - In your Podfile, remove reference to TwilioIPMessagingClient, TwilioCommon, and RCTTwilioIPMessaging.
 - Add reference to TwilioChatClient: `pod 'TwilioChatClient', '~> 0.16.0'`
 - Add reference to TwilioAccessManager, if desired: `pod 'TwilioAccessManager', '~> 0.1.1'`
 - Add reference to RCTTwilioChat: `pod 'RCTTwilioChat', :path => '../node_modules/react-native-twilio-ip-messaging/ios'`
 - Update your pod repositories with: `pod repo update`
 - Run `pod install` to perform the installation. This will remove the previous TwilioIPMessagingClient and TwilioCommon components and add the TwilioChatClient, RCTTwilioChat and optionally TwilioAccessManager.

 #### Android
  - Update your gradle imports to `compile "com.twilio:chat-android:0.11.0"`
  - Remove import of `twilio-common-android` if you had it previously
  - Update gradle.settins to use new Chat package:
  ```java
    include ':RCTTwilioChat', ':app'
    project(':RCTTwilioChat').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-twilio-ip-messaging/android')
  ```
 - Update build.gradle to compile new package: `compile project(':RCTTwilioChat')`
 - Update MainApplication.java to include new Chat package: 
  ```java
    import com.bradbumbalough.RCTTwilioChat.RCTTwilioChatPackage;
    ...
    new RCTTwilioChatPackage()
  ```
 - Remove any references to `RCTTwilioIPMessaging`

### Access Manager
 - `AccessManager` is now optional, as you can directly construct a `Client` with the token. However, if you want lifecycle events such as when the token will expire, you will need the `AccessManager`.
 - The properties `isExpired` and `identity` are no longer part of an `AccessManager` instance.
 - A new event, `onTokenWillExpire`, has been added and is fired ~3 minutes before the current token will expire.
 - The event, `onError`, has been renamed to `onTokenInvalid`.

### Channel
 - Public channels not joined now contain `membersCount` and `messagesCount`.
 
### Client
 - Client is no longer constructed with an instance of `AccessManager`. Instead, you pass your `auth_token` into it.
 - New event `onClientConnectionStateChanged` added.
 - Channels are now obtained with `getUserChannels` and `getPublicChannels`. They return an instance of a `Paginator` that you use to iterate through the results.
 - `getChannels` has been removed.
 - `getChannel` now takes an sid or uniqueName.
 - `getChannelByUniqueName` and `getChannelBySid` were removed.
 - A `register` method was added to link the `Client` instance with an `AccessManager`.
 - `deregister` was removed. Use `unregister` instead.

### Constants
 - All constants were previously prefixed with `TWM`, and are now begun with `TCH`.
  - TCHChannelOption
  - TCHChannelStatus
  - TCHChannelSynchronizationStatus
  - TCHChannelType
  - TCHClientSynchronizationStatus
  - TCHClientSynchronizationStrategy
  - TCHLogLevel

### Member, Message, UserInfo
 - No changes