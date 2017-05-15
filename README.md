# React Native Twilio Chat
[![npm version](https://badge.fury.io/js/react-native-twilio-chat.svg)](https://badge.fury.io/js/react-native-twilio-chat)

>React Native wrapper for the Twilio Programmable Chat iOS and Android SDKs

*Note - this project is currently in development for a beta release. If you are looking for the legacy package for the Twilio IP Messaging SDKs, [see the original repository here](https://github.com/ccm-innovation/react-native-twilio-ip-messaging).*

### [View migration doc from react-native-ip-messaging here](MIGRATION.md)

## Installation
```
npm install --save react-native-twilio-chat
```

### iOS - CocoaPods
Install the Twilio Chat SDK and this package via CocoaPods. See the [full Podfile example](./Example/ios/Podfile) for more details.

```ruby
pod 'Yoga', :path => '../node_modules/react-native/ReactCommon/yoga'
pod 'React', :subspecs => ['Core', /* any other subspecs you require */], :path => '../node_modules/react-native'
pod 'RCTTwilioChat', :path => '../node_modules/react-native-twilio-chat/ios'
  
source 'https://github.com/twilio/cocoapod-specs'
pod 'TwilioChatClient', '~> 0.17.1'
pod 'TwilioAccessManager', '~> 0.1.3'
```
**Note: the underlying Twilio SDKs require a minimum deployment target of `8.1`**. If your project's target is less than this you will get a CocoaPods install error (`Unable to satisfy the following requirements...`).

Make sure that you add the `$(inherited)` value to `Other Linker Flags` and `Framework Search Paths` for your target's Build Settings. This is also assuming you have already loaded React via CocoaPods as well.

### Android
In `android/settings.gradle`:

```java
include ':RCTTwilioChat', ':app'
project(':RCTTwilioChat').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-twilio-chat/android')
```

In `android/app/build.gradle`:
```java
...
dependencies {
    ...
    compile project(':RCTTwilioChat')
}

```

Register the module in `MainApplication.java`:
```Java
// import package
import com.bradbumbalough.RCTTwilioChat.RCTTwilioChatPackage;

...

// register package in getPackages()
@Override
protected List<ReactPackage> getPackages() {
    return Arrays.<ReactPackage>asList(
        new MainReactPackage(),
        new RCTTwilioChatPackage(),
        ... other packages
    );
}
```

**Note:** You might have to enable multidex in your `build.gradle` file and increase the heap size if you're getting errors while buliding. The minSdkVersion must also be at least 19, per the Twilio SDKs. 

```java
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
```javascript
/* Initialization */

import {
    AccessManager,
    Client,
    Constants
} from 'react-native-twilio-chat';

// create the access manager
const accessManager = new AccessManager(token);

// specify any handlers for events
accessManager.onTokenWillExpire = () => {
    getNewTokenFromServer()
    .then(accessManager.updateToken);
}

// create the client
const client = new Client(token);

// specify any global events
client.onError = ({error, userInfo}) => console.log(error);

// initialize the client
client.initialize();

// wait for sync to finish
client.onClientSynchronized = () => {
    client.getUserChannels()
    .then((channelPaginator) => console.log(channelPaginator.items));
}

/* Individual Channel */

// an instance of Channel is passed down in the app via props
let channel = this.props.channel

// specify channel specific events
channel.onMessageAdded = (message) => console.log(message.author + ": " + message.body);
channel.onTypingStarted = (member) => console.log(member.identity + " started typing...");
channel.onTypingEnded = (member) => console.log(member.identity + " stopped typing...");
channel.onMemberAdded = (member) => console.log(member.identity + " joined " + channel.friendlyName);

// sending a message
<TextInput 
  onChangeText={(body) => {
    this.setState({body});
    channel.typing();
  }}
  onSubmitEditing={() => { channel.sendMessage(this.state.body)} }
/>
````

## [Documentation](docs)

## Contributers 🍻
Thank you for your help in maintaining this project! Haven't contributed yet? [Check out our Contributing guidelines...](CONTRIBUTING.md).
- [bradbumbalough](https://github.com/bradbumbalough)
- [johndrkurtcom](https://github.com/johndrkurtcom)
- [jck2](https://github.com/jck2)
- [Baisang](https://github.com/Baisang)
- [thathirsch](https://github.com/thathirsch)
- [n8stowell82](https://github.com/n8stowell82)
- [svlaev](https://github.com/svlaev)
- [Maxwell2022](https://github.com/Maxwell2022)
- [bbil](https://github.com/bbil)
- [jhabdas](https://github.com/jhabdas)
- [plonkus](https://github.com/plonkus)
- [mattshen](https://github.com/mattshen)
- [Kabangi](https://github.com/Kabangi)
- [benoist](https://github.com/benoist)

## TODO 🗒
 * [x] Copy code from `programable-chat` branch on old package
 * [x] Copy issues and PRs over
 * [x] Update docs (wiki?)
 * [x] Migration guide
 * [x] Publish to npm
 * [x] Update `twilio-ip-messaging` to reference `twilio-chat`
 * [ ] 1.0 release
 * [ ] Testing

## License
This project is licensed under the [MIT License](LICENSE).
