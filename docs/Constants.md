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
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TCHChannelStatus.html)
- Invited
- Joined
- NotParticipating

### TCHChannelSynchronizationStatus
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TCHChannelSynchronizationStatus.html)
- None
- Identifier
- Metadata
- All
- Failed

### TCHChannelType
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TCHChannelType.html)
- Public
- Private

### TCHClientSynchronizationStatus
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TCHClientSynchronizationStatus.html)
- Started
- ChannelListCompleted
- Completed
- Failed

### TCHClientSynchronizationStrategy
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TCHClientSynchronizationStrategy.html)
- All
- ChannelsList

### TCHLogLevel - iOS Only
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.1/docs/Constants/TCHLogLevel.html)
- Fatal
- Critical
- Warning
- Info
- Debug

### TCHUserInfoUpdate - iOS Only
[Docs](https://media.twiliocdn.com/sdk/ios/ip-messaging/releases/0.14.2/docs/Constants/TCHUserInfoUpdate.html)
- FriendlyName
- Attributes
- ReachabilityOnline
- ReachabilityNotifiable

