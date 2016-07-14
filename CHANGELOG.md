# Changelog

## 0.2.0-rc2

#### Both
- Added `dateCreated` and `dateUpdated` to Channel
- Added `attributes` and `setAttributes` to Message
- Added `isReachabilityEnabeld` to Client
- Added `isOnline` and `isNotifiable` properties to UserInfo
- Added `onUpdate` and `close` methods to UserInfo

#### Android
- Updated Twilio SDK to 0.8.1
- Updated attributes to be JSONObject instead of Maps
- `sendMessage()` now uses a build in method instead of combing `createMessage` with `sendMessage`

#### iOS
- Updated Twilio SDK to 0.14.2
- Added `onMemberUserInfoUpdated` event for Client and Channel

#### Depreciated
- `client.getChannelBySid(sid)` is now replaced with `client.getChannel(sid)`
- `client.deregister(token)` is now replaced with `client.unregister(token)`
