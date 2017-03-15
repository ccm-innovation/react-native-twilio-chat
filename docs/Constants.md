# Constants

## Usage
```JavaScript
let {
  Constants
} = require('react-native-twilio-chat')

client.onSynchronizationStatusChanged = (status) => {
  if (status == Constants.TCHSynchronizationStatus.Completed) {
    console.log('Sync complete!')
  }
}

if (channel.status == Constants.TCHChannelStatus.Joined) {
  console.log('I can post!')
}

client.createChannel({
  type: Constants.TCHChannelType.Private
}
```

### TCHChannelStatus
- Invited
- Joined
- NotParticipating

### TCHChannelSynchronizationStatus
- None
- Identifier
- Metadata
- All
- Failed

### TCHChannelType
- Public
- Private

### TCHClientConnectionState
- Connecting
- Connected
- Disconnected
- Denied
- Error

### TCHClientSynchronizationStatus
- Started
- ChannelListCompleted
- Completed
- Failed

### TCHClientSynchronizationStrategy
- All
- ChannelsList

### TCHLogLevel
- Fatal
- Critical
- Warning
- Info
- Debug

### TCHUserInfoUpdate
- Attributes
- FriendlyName
- ReachabilityNotifiable
- ReachabilityOnline

