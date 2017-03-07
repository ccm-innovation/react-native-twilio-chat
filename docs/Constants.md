# Constants

## Usage
```JavaScript
let {
  Constants
} = require('react-native-twilio-ip-messaging')

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

### TCHLogLevel - iOS
- Fatal
- Critical
- Warning
- Info
- Debug

### TCHLogLevel - Android
- Assert
- Debug
- Error
- Info
- Verbose
- Warn

### TCHUserInfoUpdate - iOS Only
- Attributes
- FriendlyName
- ReachabilityNotifiable
- ReachabilityOnline

