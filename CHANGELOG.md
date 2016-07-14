# Changelog

## 0.2.0-rc2

#### Upgrading
Update your `package.json` to use the `0.2.0-rc2` version.
```
npm install --save react-native-twilio-ip-messaging@0.2.0-rc2
```

###### iOS
Modify your `Podfile` for the Twilio dependency as follows:
```
pod 'TwilioIPMessagingClient', '~> 0.14.2'
```

###### Android
Indicate to Android Studio to refresh the gradle dependencies.

Or, remove the cache and it will be auto-generated on the next build.

```
rm -rf $HOME/.gradle/caches/
```

#### Changes (both)
- Added `dateCreated` and `dateUpdated` to Channel
- Added `attributes` and `setAttributes` to Message
- Added `isReachabilityEnabeld` to Client
- Added `isOnline` and `isNotifiable` properties to UserInfo
- Added `onUpdate` and `close` methods to UserInfo
- Added `lastConsumedMessageIndex` and `lastConsumptionTimestamp` to Member class

#### Android
- Updated Twilio SDK to 0.8.1
- Updated attributes to be JSONObject instead of Maps
- `sendMessage()` now uses a build in method instead of combing `createMessage` with `sendMessage`
- Added `onToastFailed`, `onToastReceived`, and `onToastSubscribed` events (previously was iOS only)

#### iOS
- Updated Twilio SDK to 0.14.2
- Added `onMemberUserInfoUpdated` event for Client and Channel

#### Depreciated
- `client.getChannelBySid(sid)` is now replaced with `client.getChannel(sid)`
- `client.deregister(token)` is now replaced with `client.unregister(token)`
- `onToastRegistrationFailed` Client event is now replaced with `onToastFailed`
