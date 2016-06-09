# Constants

## Usage
```JavaScript
let {
  Constants
} = require('react-native-twilio-ip-messaging')

client.onSynchronizationStatusChanged = (status) => {
  if (status) == Constants.TWMSynchronizationStatus.Completed) {
    console.log('Sync complete!')
  }
}

if (channel.status == Constants.TWMChannelStatus.Joined) {
  console.log('I can post!')
}

client.createChannel({
  type: Constants.TWMChannelType.Private
}
```

### TWMChannelStatus
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TWMChannelStatus.html)
- Invited
- Joined
- NotParticipating

### TWMChannelSynchronizationStatus
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TWMChannelSynchronizationStatus.html)
- None
- Identifier
- Metadata
- All
- Failed

### TWMChannelType
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TWMChannelType.html)
- Public
- Private

### TWMClientSynchronizationStatus
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TWMClientSynchronizationStatus.html)
- Started
- ChannelListCompleted
- Completed
- Failed

### TWMClientSynchronizationStrategy
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TWMClientSynchronizationStrategy.html)
- All
- ChannelsList

### TWMLogLevel
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TWMLogLevel.html)
- Fatal
- Critical
- Warning
- Info
- Debug

### TWMUserInfoUpdate
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TWMUserInfoUpdate.html)
- FriendlyName
- Attributes

