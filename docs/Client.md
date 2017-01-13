# Client
The Client is the main interface for interacting with the Twilio SDKs.

## Usage
```JavaScript
// create the client
var client = new Client(accessManager);

// specify any global events
client.onError = ({error, userInfo}) => console.log(error)

// initialize the client
client.initialize()

// wait for sync to finish
client.onClientSynchronized = () => {
  client.getChannels()
  .then((channels) => console.log(channels))

  // create a new channel
  client.createChannel({
    friendlyName: 'My Channel',
    uniqueName: 'my_channel',
    type: Constants.TWMChannelType.Private
  })
  .then((channel) => console.log(channel))
}
```

## `new Client(accessManager[, synchronizationStrategy[, initialMessageCount]])`
|Name |Type |Description |
|--- |--- |--- |
|*accessManager*|AccessManager|The instance of the AccessManager used to initialize the Client
|*synchronizationStrategy*|Constants.TWMClientSynchronizationStrategy|Optional. The synchronization strategy to use during client initialization. Default: ChannelsList [See Twilio Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TWMClientSynchronizationStrategy.html)
|*initialMessageCount*|Number|Optional. The number of most recent messages to fetch automatically when synchronizing a channel. Default: 100

## Properties
|Name |Type |Description |
|--- |--- |--- |
|*accessManager*|AccessManager|Reference to the AccessManager used to initialize the client
|*userInfo*|UserInfo|The current user properties
|*version*|String|The version of the SDK
|*synchronizationStatus*|Constants.TWMClientSynchronizationStatus|The current status of the client's initialization
|*isReachabilityEnabled*|Boolean|Whether or not reachability has been enabled for the messaging instance

## Methods

#### `initialize()`
Initialize the Client with the provided Access Manager and begin synchronization.

#### `getChannels()` : Promise
Get all of the user's channels. Returns `Array<Channel>`.

#### `getChannel(sid)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*sid*|String|Sid of the channel to return
Get a single instance of a Channel. Returns `Channel`.

#### `getChannelByUniqueName(uniqueName)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*uniqueName*|String|Unique name of the channel to return
Get a single instance of a Channel. Returns `Channel`.

#### `createChannel(options)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*options*|Object|Specify the options of the channel you're creating (see below)

**Options**

|Name |Type |Description |
|--- |--- |--- |
|*friendlyName*|String|Optional. Friendly name of channel
|*uniqueName*|String|Optional. Unique name of channel
|*type*|Constants.TWMChannelType|Optional. Whether the channel will be private or public (default)
|*attributes*|Object|Optional. Attributes to attach to the channel

Create a new channel. Returns `Channel`.

#### `setLogLevel(logLevel)` **(iOS ONLY)**
|Name |Type |Description |
|--- |--- |--- |
|*logLevel*|Constants.TWMLogLevel|Set the log level of the SDK

Note: Android will ignore this configuration

#### `register(token)`
Register APNS token for push notifications. This can be obtained in `PushNotificationIOS.addListener('register', handler)`.

|Name |Type |Description |
|--- |--- |--- |
|*token*|String|The APNS token which usually comes from ‘didRegisterForRemoteNotificationsWithDeviceToken’.

#### `unregister(token)`
Unregister from push notification updates.

|Name |Type |Description |
|--- |--- |--- |
|*token*|String|The APNS token which usually comes from ‘didRegisterForRemoteNotificationsWithDeviceToken’.

#### `handleNotification(notification)`
Queue the incoming notification with the messaging library for processing - for React Native, this will come in `PushNotificationIOS.addEventListener('notification', handleNotification)`.

|Name |Type |Description |
|--- |--- |--- |
|*notification*|Object|The incoming notification.

#### `shutdown()`
Terminate the instance of the client, and remove all the listeners. Note: this does not remove channel specific listeners.

### Events
Instead of having to worry about creating native listeners, simply specify handlers on the client instance for the events you want to be notified about.

#### `onClientSynchronized()`
Fired when the client has finished synchronizing and populated all of its attributes.

#### `onSynchronizationStatusChanged(status)`
|Name |Type |Description |
|--- |--- |--- |
|*status*|Constants.TWMClientSynchronizationStatus|The client's synchronization status

#### `onChannelAdded(channel)`
|Name |Type |Description |
|--- |--- |--- |
|*channel*|Channel|An instance of the new channel

#### `onChannelChanged(channel)`
|Name |Type |Description |
|--- |--- |--- |
|*channel*|Channel|An instance of the changed channel

#### `onChannelDeleted(channel)`
|Name |Type |Description |
|--- |--- |--- |
|*channel*|Channel|An instance of the deleted channel

#### `onChannelSynchronizationStatusChanged({channelSid, status})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*status*|Constants.TWMChannelSynchronizationStatus|The synchronization status of the channel

#### `onMemberJoined({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*member*|Object|The joined member

#### `onMemberChanged({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*member*|Object|The changed member

#### `onMemberLeft({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*member*|Object|The left member

#### `onMemberUserInfoUpdated({updated, userInfo})` **iOS Only**
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The Sid of the channel the member is part of
|*updated*|Constants.TWMUserInfoUpdated|The type of userInfo update (**iOS Only**)
|*userInfo*|UserInfo|The new UserInfo instance

#### `onMessageAdded({channelSid, message})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*message*|Message|The instance of the new Message

#### `onMessageChanged({channelSid, message})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*message*|Message|The instance of the changed Message

#### `onMessageDeleted({channelSid, message})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*message*|Message|The instance of the deleted Message

#### `onError({error, userId})`
|Name |Type |Description |
|--- |--- |--- |
|*error*|String|The error message from the SDK
|*userInfo*|Object|The Error's userInfo method object

#### `onTypingStarted({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*member*|Object|The member who started typing

#### `onTypingEnded({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*member*|Object|The member who ended typing

#### `onToastSubscribed()`

#### `onToastReceived({channelSid, messageSid})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*messageSid*|String|The message sid (if applicable)

#### `onToastFailed({error, userId})`
|Name |Type |Description |
|--- |--- |--- |
|*error*|String|The error message from the SDK
|*userInfo*|Object|The Error's userInfo method object

#### `onUserInfoUpdated({updated, userInfo})`
|Name |Type |Description |
|--- |--- |--- |
|*updated*|Constants.TWMUserInfoUpdated|The type of userInfo update (**iOS Only**)
|*userInfo*|UserInfo|The new UserInfo instance
