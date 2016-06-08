# React Native Twilio IP Messaging
>React Native wrapper for the Twilio IP Messaging SDKs

## Installation
```npm install --save react-native-twilio-ip-messaging```

### iOS
1. Install Twilio IP Messaging SDK via CocoaPods.

    ```
    source 'https://github.com/twilio/cocoapod-specs'
    pod 'TwilioIPMessagingClient', '~> 0.14.1'
    ```
    
2. Add `RCTTwilioIPMessaging.xcxcodeproj` to your Project's Libraries (located in `./node_modules/react-native-twilio-ip-messaging/`).
3. Drag `libRCTTwilioIPMessaging.a` from the Products group to your targets `Build Phases` -> `Link Binary With Libraries` phase.

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
channel.onMessageAdded = ({message}) => console.log(message.author + ": " + message.body)
channel.onTypingStarted = ({member}) => console.log(member.identity + " started typing...")
channel.onTypingEnded = ({member}) => console.log(member.identity + " stopped typing...")
channel.onMemberAdded = ({member}) => console.log(member.identity + " joined " + channel.friendlyName)

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
