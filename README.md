# React Native Twilio IP Messaging
>React Native wrapper for the Twilio IP Messaging SDKs

## Installation
```npm install --save react-native-twilio-ip-messaging```

### iOS
Install the Twilio IP Messaging SDK and this package via CocoaPods.

```
pod 'RCTTwilioIPMessaging', :path => '../node_modules/react-native-twilio-ip-messaging'
  
source 'https://github.com/twilio/cocoapod-specs'
pod 'TwilioIPMessagingClient', '~> 0.14.1'
```

Make sure that you add the `$(inherited)` value to `Other Linker Flags` and `Framework Search Paths` for your target's Build Settings. This is also assuming you have already loaded React via CocoaPods as well.
    
**Checkout the Android release candidate at branch `0.2.0-rc2`.**

## Usage
```JavaScript
/* Initialization */

let {
    AccessManager,
    Client,
    Constants
} = require('react-native-twilio-ip-messaging')

// create the access manager
var accessManager = new AccessManager(token);

// specify any handlers for events
accessManager.onTokenExpired = () => {
    getNewTokenFromServer()
    .then(accessManager.updateToken)
}

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
}

/* Individual Channel */

// somehow an instance of Channel is passed down in the app
var channel = this.props.channel

// specify channel specific events
channel.onMessageAdded = (message) => console.log(message.author + ": " + message.body)
channel.onTypingStarted = (member) => console.log(member.identity + " started typing...")
channel.onTypingEnded = (member) => console.log(member.identity + " stopped typing...")
channel.onMemberAdded = (member) => console.log(member.identity + " joined " + channel.friendlyName)

// sending a message
<TextInput
    onChangeText={(body) => {
        this.setState({body})
        channel.typing()
    }}
    onSubmitEditing={() => channel.sendMessage(this.state.body)}
/>
````

####[Documentation](docs)
