# AccessManager
The AccessManager is Twilio's abstraction of authenticating your instance of Twilio from the functionality of Programable Chat. It is optional in the lastest release of the SDKs.

## `new AccessManager(token)`
|Name |Type |Description |
|--- |--- |--- |
|*token*|String|The access token provided by your server

## Properties
|Name |Type |Description |
|--- |--- |--- |
|*token*|String|The current token
|*expires*|Date|The timestamp of when the token will expire

### Methods

#### `registerClient()` **iOS Only**
Call to attach the TwilioClient to the AccessManager so that `updateToken` automatically passes through. Otherwise, you'll need to update both.

#### `removeListeners()`
Call when unmounting or closing the Chat session.

#### `updateToken(newToken)`
Updates the token associated with the Access Manager.
|Name |Type |Description |
|--- |--- |--- |
|*newToken*|String|A new token to renew your instance with

### Events
You can specify handlers for events on the `accessManager` instance itself. For example, if you wanted to listen to the token expiration event, you would set `accessManager.onTokenExpired = function() { console.log('Token expired') }`.

#### `onTokenExpired()`
Fired when the current token has expired.

#### `onTokenWillExpire()`
Fired 3 minuts before the current token will expire.

#### `onTokenInvalid()`
Fired when the token provided to the manager is invalid.
