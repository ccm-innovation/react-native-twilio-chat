# Client
The Client is the main interface for interacting with the Twilio SDKs. 

## `new Client(accessManager[, synchronizationStrategy[, initialMessageCount]])`
|Name |Type |Description |
|--- |--- |--- |
|`accessManager`|AccessManager|The instance of the AccessManager used to initialize the Client
|`synchronizationStrategy`|Constants.TWMClientSynchronizationStrategy|Optional. The syncrhonization strategy to use during client initialization. Default: ChannelsList [See Twilio Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TWMClientSynchronizationStrategy.html)
|`initialMessageCount`|Number|Optional. The number of most recent messages to fetch automatically when synchronizing a channel. Default: 100

## Properties
|Name |Type |Description |
|--- |--- |--- |
|`accessManager`|AccessManager|Reference to the AccessManager used to initialize the client
|`userInfo`|UserInfo|The current user properties
|`version`|String|The version of the SDK
|`synchronizationStatus`|Constants.TWMClientSynchronizationStatus|The current status of the client's initialization

## Methods

#### `initialize()`
Initialize the Client with the provided Access Manager and begin synchronization.

#### `getChannels()` : Promise
Get all of the user's channels. Returns `Array<Channel>`.

#### `getChannelBySid(sid)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|`sid`|String|Sid of the channel to return
Get a single instance of a Channel. Returns `Channel`.

#### `getChannelByUniqueName(uniqueName)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|`uniqueName`|String|Unique name of the channel to return
Get a single instance of a Channel. Returns `Channel`.

#### `createChannel(options)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|`options`|Object|Specify the options of the channel you're creating (see below)

**Options**

|Name |Type |Description |
|--- |--- |--- |
|`friendlyName`|String|Optional. Friendly name of channel
|`uniqueName`|String|Optional. Unique name of channel
|`type`|Constants.TWMChannelType|Optional. Whether the channel will be private or public (default) 
|`attributes`|Object|Optional. Attributes to attach to the channel

Create a new channel. Returns `Channel`.

#### `setLogLevel(logLevel)`
|Name |Type |Description |
|--- |--- |--- |
|`logLevel`|Constants.TWMLogLevel|Set the log level of the SDK

#### `shutdown()`
Terminate the instance of the client, and remove all the listeners. Note: this does not remove channel specific listeners.

### Events
Instead of having to worry about creating native listeners, simply specify handlers on the client instance for the events you want to be notified about.

#### `onClientSynchronized()`
Fired when the client has finished synchronizing and populated all of its attributes.

#### `onSynchronizationStatusChanged(status)`
|Name |Type |Description |
|--- |--- |--- |
|`status`|Constants.TWMClientSynchronizationStatus|The client's synchronization status

#### `onChannelAdded(channel)`
|Name |Type |Description |
|--- |--- |--- |
|`channel`|Channel|An instance of the new channel

#### `onChannelChanged(channel)`
|Name |Type |Description |
|--- |--- |--- |
|`channel`|Channel|An instance of the changed channel

#### `onChannelDeleted(channel)`
|Name |Type |Description |
|--- |--- |--- |
|`channel`|Channel|An instance of the deleted channel

#### `onChannelSynchronizationStatusChanged({channelSid, status})`
|Name |Type |Description |
|--- |--- |--- |
|`channelSid`|String|The sid of the channel
|`status`|Constants.TWMChannelSynchronizationStatus|The synchronization status of the channel

#### `onMemberJoined({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|`channelSid`|String|The sid of the channel
|`member`|Object|The joined member

#### `onMemberChanged({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|`channelSid`|String|The sid of the channel
|`member`|Object|The changed member

#### `onMemberLeft({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|`channelSid`|String|The sid of the channel
|`member`|Object|The left member

#### `onMessageAdded({channelSid, message})`
|Name |Type |Description |
|--- |--- |--- |
|`channelSid`|String|The sid of the channel
|`message`|Message|The instance of the new Message

#### `onMessageChanged({channelSid, message})`
|Name |Type |Description |
|--- |--- |--- |
|`channelSid`|String|The sid of the channel
|`message`|Message|The instance of the changed Message

#### `onMessageDeleted({channelSid, message})`
|Name |Type |Description |
|--- |--- |--- |
|`channelSid`|String|The sid of the channel
|`message`|Message|The instance of the deleted Message

#### `onError({error, userId})`
|Name |Type |Description |
|--- |--- |--- |
|`error`|String|The error message from the SDK
|`userInfo`|Object|The Error's userInfo method object

#### `onTypingStarted({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|`channelSid`|String|The sid of the channel
|`member`|Object|The member who started typing

#### `onTypingEnded({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|`channelSid`|String|The sid of the channel
|`member`|Object|The member who ended typing

#### `onToastSubscribed()`

#### `onToastReceived({channelSid, message})`
|Name |Type |Description |
|--- |--- |--- |
|`channelSid`|String|The sid of the channel
|`message`|Message|The instance of the Message in the toast

#### `onToastRegistrationFailed({error, userId})`
|Name |Type |Description |
|--- |--- |--- |
|`error`|String|The error message from the SDK
|`userInfo`|Object|The Error's userInfo method object

#### `onUserInfoUpdated({updated, userInfo})`
|Name |Type |Description |
|--- |--- |--- |
|`updated`|Constants.TWMUserInfoUpdated|Whether the update was friendly name or attributes
|`userInfo`|UserInfo|The new UserInfo instance
