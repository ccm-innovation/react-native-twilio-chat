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










