# AccessManager
The AccessManager is Twilio's separation of authenticating your instance of Twilio from the functionality of IP Messaging.

## `var accessManager = new AccessManager(token)`
|Name |Type |Description |
|--- |--- |--- |
|`token`|String|The access token provided by your server

## Properties
|Name |Type |Description |
|--- |--- |--- |
|`identity`|String|The identity (username) of your access manager
|`token`|String|The current token
|`isExpired`|Boolean|Whether or not the token has expired
|`expires`|Date|The timestamp of when the token will expire

### Methods

#### `updateToken(newToken)`
|Name |Type |Description |
|--- |--- |--- |
|`newToken`|String|A new token to renew your instance with

### Events
You can specify handlers for events on the `accessManager` instance itself. For example, if you wanted to listen to the token expiration event, you would set `accessManager.onTokenExpired = function() { console.log('Token expired') }`.

#### `onTokenExpired()`
Fired when the current token expires
#### `onTokenError({error, userInfo})`
Generic error handler for Access Manager issues. Returns the error and objective-c userInfo attributes.

|Name |Type |Description |
|--- |--- |--- |
|`error`|String|The error message from the SDK
|`userInfo`|Object|The contents of the userInfo method of the Error
