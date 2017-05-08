# Client
The Client is the main interface for interacting with the Twilio SDKs.

## Usage
```JavaScript
// create the client
const client = new Client(token);

// specify any global events
client.onError = ({error, userInfo}) => console.log(error);

// initialize the client
client.initialize();

// wait for sync to finish
client.onClientSynchronized = () => {
  client.getUserChannels()
  .then((channelPaginator) => console.log(channelPaginator));

  // create a new channel
  client.createChannel({
    friendlyName: 'My Channel',
    uniqueName: 'my_channel',
    type: Constants.TCHChannelType.Private
  })
  .then((channel) => console.log(channel));
}
```

## `new Client(token[, synchronizationStrategy[, initialMessageCount]])`
|Name |Type |Description |
|--- |--- |--- |
|*token*|String|The Access Token provided by your server
|*synchronizationStrategy*|Constants.TCHClientSynchronizationStrategy|Optional. The synchronization strategy to use during client initialization. Default: ChannelsList [See Twilio Docs](https://media.twiliocdn.com/sdk/ios/chat/releases/0.17.1/docs/Constants/TCHClientSynchronizationStrategy.html)
|*initialMessageCount*|Number|Optional. The number of most recent messages to fetch automatically when synchronizing a channel. Default: 100

## Properties
|Name |Type |Description |
|--- |--- |--- |
|*userInfo*|UserInfo|The current user properties
|*version*|String|The version of the SDK
|*synchronizationStatus*|Constants.TCHClientSynchronizationStatus|The current status of the client's initialization
|*isReachabilityEnabled*|Boolean|Whether or not reachability has been enabled for the messaging instance

## Methods

#### `createChannel(options)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*options*|Object|Specify the options of the channel you're creating (see below)

**Options**

|Name |Type |Description |
|--- |--- |--- |
|*friendlyName*|String|Optional. Friendly name of channel
|*uniqueName*|String|Optional. Unique name of channel
|*type*|Constants.TCHChannelType|Optional. Whether the channel will be private or public (default)
|*attributes*|Object|Optional. Attributes to attach to the channel

Create a new channel. Returns `Channel`.

#### `getChannel(sid)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*sid*|String|Sid of the channel to return
Get a single instance of a Channel. Returns `Channel`.

#### `getPublicChannels()` : Promise
Get all of the public channels. Returns an instance of `Paginator`.

#### `getUserChannels()` : Promise
Get all of the user's channels. Returns an instance of `Paginator`.

#### `handleNotification(notification)`
Queue the incoming notification with the messaging library for processing - for React Native, this will come in `PushNotificationIOS.addEventListener('notification', handleNotification)`.

|Name |Type |Description |
|--- |--- |--- |
|*notification*|Object|The incoming notification.

#### `initialize()`
Initialize the Client with the provided Access Manager and begin synchronization.

#### `register(token)`
Register APNS token for push notifications. This can be obtained in `PushNotificationIOS.addListener('register', handler)`.

|Name |Type |Description |
|--- |--- |--- |
|*token*|String|The APNS token which usually comes from ‘didRegisterForRemoteNotificationsWithDeviceToken’.

#### `setLogLevel(logLevel)`
|Name |Type |Description |
|--- |--- |--- |
|*logLevel*|Constants.TCHLogLevel|Set the log level of the SDK

#### `shutdown()`
Terminate the instance of the client, and remove all the listeners. Note: this does not remove channel specific listeners.

#### `unregister(token)`
Unregister from push notification updates.

|Name |Type |Description |
|--- |--- |--- |
|*token*|String|The APNS token which usually comes from ‘didRegisterForRemoteNotificationsWithDeviceToken’.

### Events
Instead of having to worry about creating native listeners, simply specify handlers on the client instance for the events you want to be notified about.

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

#### `onChannelInvited(channel)`
|Name |Type |Description |
|--- |--- |--- |
|*channel*|Channel|An instance of the changed channel

#### `onChannelSynchronizationStatusChanged({channelSid, status})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*status*|Constants.TCHChannelSynchronizationStatus|The synchronization status of the channel

#### `onClientConnectionStateChanged(state)`
|Name |Type |Description |
|--- |--- |--- |
|*status*|Constants.TCHClientConnectionState|The client's connection state

#### `onClientSynchronized()`
Fired when the client has finished synchronizing and populated all of its attributes.

#### `onError({error, userId})`
|Name |Type |Description |
|--- |--- |--- |
|*error*|String|The error message from the SDK
|*userInfo*|Object|The Error's userInfo method object

#### `onMemberChanged({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*member*|Object|The changed member

#### `onMemberJoined({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*member*|Object|The joined member

#### `onMemberLeft({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*member*|Object|The left member

#### `onMemberUserInfoUpdated({updated, userInfo})` **iOS Only**
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The Sid of the channel the member is part of
|*updated*|Constants.TCHUserInfoUpdated|The type of userInfo update (**iOS Only**)
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

#### `onSynchronizationStatusChanged(status)`
|Name |Type |Description |
|--- |--- |--- |
|*status*|Constants.TCHClientSynchronizationStatus|The client's synchronization status

#### `onToastReceived({channelSid, messageSid})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*messageSid*|String|The message sid (if applicable)

#### `onToastSubscribed()`

#### `onTypingEnded({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*member*|Object|The member who ended typing

#### `onToastFailed({error, userId})`
|Name |Type |Description |
|--- |--- |--- |
|*error*|String|The error message from the SDK
|*userInfo*|Object|The Error's userInfo method object


#### `onTypingStarted({channelSid, member})`
|Name |Type |Description |
|--- |--- |--- |
|*channelSid*|String|The sid of the channel
|*member*|Object|The member who started typing

#### `onUserInfoUpdated({updated, userInfo})`
|Name |Type |Description |
|--- |--- |--- |
|*updated*|Constants.TCHUserInfoUpdated|The type of userInfo update
|*userInfo*|UserInfo|The new UserInfo instance
