# React Native Twilio IP Messaging
[![npm version](https://badge.fury.io/js/react-native-twilio-ip-messaging.svg)](https://badge.fury.io/js/react-native-twilio-ip-messaging)

>React Native wrapper for the Twilio IP Messaging SDKs

####[Changelog](CHANGELOG.md)

## Installation
```npm install --save react-native-twilio-ip-messaging```

### iOS
Install the Twilio IP Messaging SDK and this package via CocoaPods.

```
pod 'RCTTwilioIPMessaging', :path => '../node_modules/react-native-twilio-ip-messaging/ios'
  
source 'https://github.com/twilio/cocoapod-specs'
pod 'TwilioIPMessagingClient', '~> 0.14.2'
```
**Note: the underlying Twilio SDKs require a minimum deployment target of `8.1`**. If your project's target is less than this you will get a CocoaPods install error (`Unable to satisfy the following requirements...`).

Make sure that you add the `$(inherited)` value to `Other Linker Flags` and `Framework Search Paths` for your target's Build Settings. This is also assuming you have already loaded React via CocoaPods as well.
            
### Android
In `android/settings.gradle`:

```
include ':RCTTwilioIPMessaging', ':app'
project(':RCTTwilioIPMessaging').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-twilio-ip-messaging/android')
```

In `android/app/build.gradle`:
```
...
dependencies {
    ...
    compile project(':RCTTwilioIPMessaging')
}

```

Register the module in `MainActivity.java` by calling addPackage():
```Java
// import package
import com.bradbumbalough.RCTTwilioIPMessaging.RCTTwilioIPMessagingPackage;

...

// register package in getPackages()
@Override
protected List<ReactPackage> getPackages() {
    return Arrays.<ReactPackage>asList(
        ... other packages
        new RCTTwilioIPMessagingPackage(),
        new MainReactPackage()
    );
}
```

**Note:** You might have to enable multidex in your `build.gradle` file and increase the heap size if you're getting errors while buliding. The minSdkVersion must also be at least 19, per the Twilio SDKs. 
```
android {
    ....
    dexOptions {
        javaMaxHeapSize "2048M"
    }
    
    defaultConfig {
        ...
        minSdkVersion 19
        multiDexEnabled true
    }
```

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
