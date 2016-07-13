# Changelog

## 0.2.0-rc2

#### Both
- Added `dateCreated` and `dateUpdated` to Channel (99ee06d, 1cc6550)
- Added `attributes` and `setAttributes` to Message (2c5933c)
- Added `isReachabilityEnabeld` to Client (e006cb9)
- Added `isOnline` and `isNotifiable` properties to UserInfo (6690496)
- Added `onUpdate` and `close` methods to UserInfo (3f60b19)

#### Android
- Updated Twilio SDK to 0.8.1 (5087208)
- Updated attributes to be JSONObject instead of Maps (064b8f5, 62329f2)
- `sendMessage()` now uses a build in method instead of combing `createMessage` with `sendMessage` (5e5f965)

#### iOS
- Updated Twilio SDK to 0.14.2 (e2f1188)
- Added `onMemberUserInfoUpdated` event for Client and Channel (f2be338)

#### Depreciated
- `client.getChannelBySid(sid)` is now replaced with `client.getChannel(sid)`
- `client.deregister(token)` is now replaced with `client.unregister(token)`
