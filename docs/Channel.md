# Channel
A class that handles the interactions with a specific channel.

## Usage
```JavaScript
let channel = this.props.channel

// specify channel specific events
channel.onMessageAdded = (message) => console.log(message.author + ": " + message.body);
channel.onTypingStarted = (member) => console.log(member.identity + " started typing...");
channel.onTypingEnded = (member) => console.log(member.identity + " stopped typing...");
channel.onMemberAdded = (member) => console.log(member.identity + " joined " + channel.friendlyName);

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
      this.setState({body});
      channel.typing();
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
|*attributes*|Object|Any custom attributes added to the channel
|*synchronizationStatus*|Constants.TCHChannelSynchronizationStatus|Current synchronization status of the channel
|*status*|Constants.TCHChannelStatus|The user's association with the channel
|*type*|Constants.TCHChannelType|Whether the channel is public or private
|*dateCreated*|Date|When the channel was created
|*dateUpdated*|Date|When the channel was last updated
|*createdBy*|String|The identity of the channel creator

*On public channels accessed through getPublicChannels, you will have these additional properties*

|Name |Type |Description |
|--- |--- |--- |
|*messagesCount*|Number|Count of messages
|*membersCount*|Number|Count of members

## Methods

#### `advanceLastConsumedMessageIndex(index)`
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The index of the message consumed (should be greater than last consumed index)

#### `add(identity)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*identity*|String|The identity of the user to add (without inviting)

#### `close()`
Close the channel and remove all listeners (call in `componentWillUnmount`).

#### `declineInvitation()` : Promise
Decline joining the channel, in reply to an invitation.

#### `destroy()` : Promise
Delete a channel.

#### `getLastConsumedMessageIndex()` : Promise
Returns `Number` index.

#### `getMember(identity)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*identity*|String|The identity of the user to return
Returns a `Member` instance.

#### `getMembers()` : Promise
Returns an `Array<Member>` instances.

#### `getMembersCount()` : Promise
Returns the number of members for this channel.

#### `getMessage(index)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The index of the message to get

#### `getMessages(count = 10)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*count*|Number|Default 10. The number of most recent messages to get
Returns an `Array<Message>` instances.

#### `getMessagesAfter(index, count)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The starting point index
|*count*|Number|The number of succeeding messages to return
Returns an `Array<Message>` instances.

#### `getMessagesBefore(index, count)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The starting point index
|*count*|Number|The number of preceding messages to return
Returns an `Array<Message>` instances.

#### `getMessageForConsumption(index)` : Promise **(iOS Only)**
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The index of the last message reported as read (may refer to a deleted message)

#### `getMessagesCount()` : Promise
Returns the number of messages for this channel.

#### `getUnconsumedMessagesCount()` : Promise
Returns the number of unread messages for this channel.

#### `initialize()` : Promise
Synchronize the channel with the server. May not be needed depending on if you set synchronizationStrategy to `All` during the client initialization. Otherwise, without calling `initialize` you won't get notificed when any events pertaining to this channel occur.

#### `invite(identity)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*identity*|String|The identity of the user to invite

#### `join()` : Promise
Join the channel (if not a member or in reply to an invitation).

#### `leave()` : Promise
Leave a channel.

#### `remove(identity)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*identity*|String|The identity of the user to remove

#### `removeMessage(index)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The index of the message to delete

#### `sendMessage(body, attributes)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*body*|String|The message body
|*attributes*|Object|Any properties you want associated with the message (Optional)

#### `setAllMessagesConsumed()`
Update the last consumed index for this Member and Channel to the max message currently on this device.

#### `setAttributes(attributes)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*attributes*|Object|Any properties you want associated with the channel

#### `setFriendlyName(friendlyName)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*friendlyName*|String|Specify a friendly name for the channel

#### `setLastConsumedMessageIndex(index)`
|Name |Type |Description |
|--- |--- |--- |
|*index*|Number|The index of the consumed message
Returns a `Message` instance.

#### `setUniqueName(uniqueName)` : Promise
|Name |Type |Description |
|--- |--- |--- |
|*uniqueName*|String|Specify a unique name for the channel

#### `typing()`
Invoke whenever the user is typing a message.

## Events

#### `onChanged()`

#### `onDeleted()`

#### `onMemberChanged(member)`
|Name |Type |Description |
|--- |--- |--- |
|*member*|Member|The changed member instance

#### `onMemberJoined(member)`
|Name |Type |Description |
|--- |--- |--- |
|*member*|Member|The instance of the new member

#### `onMemberLeft(member)`
|Name |Type |Description |
|--- |--- |--- |
|*member*|Member|The member instance who left

#### `onMemberUserInfoUpdated({updated, userInfo})` **iOS Only**
|Name |Type |Description |
|--- |--- |--- |
|*updated*|Constants.TCHUserInfoUpdated|The type of userInfo update (**iOS Only**)
|*userInfo*|UserInfo|The new UserInfo instance

#### `onMessageAdded(message)`
|Name |Type |Description |
|--- |--- |--- |
|*message*|Message|The instance of the new message

#### `onMessageChanged(message)`
|Name |Type |Description |
|--- |--- |--- |
|*message*|Message|The instance of the changed message

#### `onMessageDeleted(message)`
|Name |Type |Description |
|--- |--- |--- |
|*message*|Message|The instance of the deleted message

#### `onSynchronizationStatusChanged(status)`
|Name |Type |Description |
|--- |--- |--- |
|*status*|Constants.TCHChannelSynchronizationStatus|The new synchronization status of the channel

#### `onToastReceived(message)`
|Name |Type |Description |
|--- |--- |--- |
|*message*|Message|The instance of the toast message

#### `onTypingStarted(member)`
|Name |Type |Description |
|--- |--- |--- |
|*member*|Member|The member who started typing

#### `onTypingEnded(member)`
|Name |Type |Description |
|--- |--- |--- |
|*member*|Member|The member who ended typing