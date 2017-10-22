# ChannelDescriptor
Contains channel information.
Unlike Channel, this information won't be updated in realtime. To have refreshed data, user should query channel descriptors again.

## Usage
```JavaScript
let channelDescriptor = this.props.channelDescriptor;

channelDescriptor.getChannel()
.then((channel) => {
  // full Channel object
  console.log(channel)
}

```

## Properties
|Name |Type |Description |
|--- |--- |--- |
|*sid*|String|The sid of the channel (shouldn't need this in an instance, all methods are pre-bound)
|*friendlyName*|String|Friendly name of the channel
|*uniqueName*|String|Unique name of the channel
|*attributes*|Object|Any custom attributes added to the channel
|*dateCreated*|Date|When the channel was created
|*dateUpdated*|Date|When the channel was last updated
|*createdBy*|String|The identity of the channel creator
|*messagesCount*|Number|Count of messages
|*membersCount*|Number|Count of members

## Methods

#### `getChannel()`
Obtain full Channel object
