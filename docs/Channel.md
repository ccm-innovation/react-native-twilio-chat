# Channel
A class that handles the interactions with a specific channel.

## Usage
```JavaScript
var channel = this.props.channel

// specify channel specific events
channel.onMessageAdded = ({message}) => console.log(message.author + ": " + message.body)
channel.onTypingStarted = ({member}) => console.log(member.identity + " started typing...")
channel.onTypingEnded = ({member}) => console.log(member.identity + " stopped typing...")
channel.onMemberAdded = ({member}) => console.log(member.identity + " joined " + channel.friendlyName)

channel.getMessages(20)
.then((messages) => {
  // array of message instances
  console.log(messages)
}

// mark all messages as read, etc
channel.setAllMessagesConsumed()

// sending a message
<TextInput
    onChangeText={(body) => {
        this.setState({body})
        channel.typing()
    }}
    onSubmitEditing={() => channel.sendMessage(this.state.body)}
/>
```

## Properties
|Name |Type |Description |
|--- |--- |--- |
|*sid*|String|The sid of the channel (shouldn't need this in an instance, all methods are pre-bound)
|*friendlyName*|String|Friendly name of the channel
|*uniqueName*|String|Unique name of the channel
|*synchronizationStatus*|Constants.TWMChannelSynchronizationStatus|Current synchronization status of the channel
|*status*|Constants.TWMChannelStatus|The user's association with the channel
|*type*|Constants.TWMChannelType|Whether the channel is public or private
|*attributes*|Object|Any custom attributes added to the channel

## Methods

#### `initialize()` : Promise
Synchronize the channel with the server. May not be needed depending on if you set synchronizationStrategy to `All` during the client initialization. Otherwise, without calling `initialize` you won't get notificed when any events pertaining to this channel occur.

#### `setAttributes(attributes)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*attributes*|Object|Any propertites you want associated with the channel

#### `setFriendlyName(friendlyName)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*friendlyName*|String|Specify a friendly name for the channel

#### `setUniqueName(uniqueName)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*uniqueName*|String|Specify a unique name for the channel

#### `join()` : Promise
Join the channel (if not a member or in reply to an invitation).

#### `declineInvitation()` : Promise
Decline joining the channel, in reply to an invitation.

#### `leave()` : Promise
Leave a channel.

#### `destory()` : Promise
Delete a channel.

#### `typing()`
Invoke whenever the user is typing a message.

#### `getMember(identity)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*identity*|String|The identity of the user to return
Returns a `Member` instance.

#### `getMembers()` : Promise
Returns an `Array<Member>` instances.

#### `add(identity)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*identity*|String|The identity of the user to add (without inviting)

#### `invite(identity)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*identity*|String|The identity of the user to invite

#### `remove(identity)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*identity*|String|The identity of the user to remove

#### `lastConsumedMessageIndex()` : Promise
Returns `Number` index.

#### `sendMessage(body)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*body*|String|The message body

#### `removeMessage(index)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The index of the message to delete

#### `getMessages(count = 10)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*count*|Number|Default 10. The number of most recent messages to get
Returns an `Array<Message>` instances.

#### `getMessagesBefore(index, count)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The starting point index
|*count*|Number|The number of preceeding messages to return
Returns an `Array<Message>` instances.

#### `getMessagesAfter(index, count)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The starting point index
|*count*|Number|The number of succeeding messages to return
Returns an `Array<Message>` instances.

#### `getMessage(index)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The index of the message to get

#### `getMessageForConsumption(index)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The index of the last message reported as read (may refer to a deleted message)

#### `setLastConsumedMessageIndex(index)`
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The index of the consumed message
Returns a `Message` instance.

#### `advanceLastConsumedMessageIndex(index)`
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The index of the message consumed (should be greated than last consumed index)

#### `setAllMessagesConsumed()`
Update the last consumed index for this Member and Channel to the max message currently on this device.

#### `close()`
Close the channel and remove all listeners (call in `componentWillUnmount`).
