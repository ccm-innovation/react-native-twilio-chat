'use strict';

import React, {
  Component,
} from 'react';
import {
  Linking,
  Platform,
  ActionSheetIOS,
  Dimensions,
  View,
  Text,
  Navigator,
} from 'react-native';

var GiftedMessenger = require('react-native-gifted-messenger');
var Communications = require('react-native-communications');

const BOT_GREETINGS = [
  "Hello!",
  "Good day, mate!",
  "Why hello there!",
  "Hola!",
  "Bonjour",
  "I'm booting up...",
  "Hiya!",
  "Heellllooooooooooooooo"
]

const BOT_QUESTIONS = [
  "Let's be friends! What can I call you?",
  "I'm your new pal! What's your name?",
  "I am here to serve, how shall I address you?",
  "You're my new friend! What is your preferred name?",
  "Let me update my records... what is your name?",
  "I'll help you get things started. What is your name?"
]

const BOT_CONFIRMATIONS = [
  "You are now cleared to chat!",
  "Feel free to chat with the group",
  "I have now connected you to the channel",
  "Chat away!",
  "Feel free to start chatting",
  "The group awaits your input",
  "Go for the gold!"
]

var DeviceInfo = require('react-native-device-info')

let {
  Client,
  Constants,
  AccessManager
} = require('react-native-twilio-ip-messaging')


var STATUS_BAR_HEIGHT = Navigator.NavigationBar.Styles.General.StatusBarHeight;
if (Platform.OS === 'android') {
  var ExtraDimensions = require('react-native-extra-dimensions-android');
  var STATUS_BAR_HEIGHT = ExtraDimensions.get('STATUS_BAR_HEIGHT');
}


class GiftedMessengerContainer extends Component {

  constructor(props) {
    super(props);

    this._isMounted = false;
    this._messages = this.getInitialMessages();

    this.state = {
      messages: this._messages,
      isLoadingEarlierMessages: false,
      typingMessage: '',
      allLoaded: false,
    };

  }
  
  getToken(identity) {
    return fetch('http://localhost:3000/token?device=iOS&identity=' + identity, {
      method: 'get'
    })
    .then((res) => {
      return res.json()
    })
  }
  
  parseMessage(message) {
    return {
      uniqueId: message.sid,
      text: message.body,
      name: message.author,
      position: message.author == this.state.client.userInfo.identity ? 'right' : 'left',
      date: message.timestamp
    }
  }
  
  initializeMessenging(identity) {
    this.getToken(identity)
    .then(({token}) => {
      var accessManager = new AccessManager(token)
      accessManager.onTokenExpired = () => {
        this.getToken(identity)
        .then(({token}) => accessManager.updateToken(token))
      }
      accessManager.onError = ({error}) => {
        console.log(error)
      }
      
      var client = new Client(accessManager)
           
      client.onError = ({error, userInfo}) => console.log(error)

      client.onClientSynchronized = () => {
        
        client.getChannelByUniqueName('general')
        .then((channel) => {
          channel.initialize()
          .then(() => {
            if (channel.status != Constants.TWMChannelStatus.Joined) {
              channel.join()
            }
          })
          .catch(({error}) => {
            console.log(error)
          })
          
          channel.onTypingStarted = (member) => {
            this.setState({typingMessage: member.userInfo.identity + ' is typing...'})
          }
          
          channel.onTypingEnded = (member) => {
            this.setState({typingMessage: ''})
          }
          
          channel.onMessageAdded = (message) => this.handleReceive(this.parseMessage(message))
          
          this.setState({client, channel})        
        }) 
      }
      
      client.initialize()
    })
  }
  
  botMessage(message, time = 1000) {
    this.setState({typingMessage: 'MessagingBot is typing...'})
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        this.setState({typingMessage: ''})
        this.handleReceive({
          text: message,
          uniqueId: Math.round(Math.random() * 10000),
          name: 'MessagingBot',
          position: 'left',
          internal: true
        })
        resolve() 
      },time)
    })
  }

  componentDidMount() {
      setTimeout(() => {
        this.botMessage(BOT_GREETINGS[Math.floor(Math.random()*BOT_GREETINGS.length)])
        .then(() => this.botMessage(BOT_QUESTIONS[Math.floor(Math.random()*BOT_QUESTIONS.length)], 2000))
      },500)
  }

  componentWillUnmount() {
    this._isMounted = false;
  }

  getInitialMessages() {
    return []
  }

  setMessageStatus(uniqueId, status) {
    let messages = [];
    let found = false;

    for (let i = 0; i < this._messages.length; i++) {
      if (this._messages[i].uniqueId === uniqueId) {
        let clone = Object.assign({}, this._messages[i]);
        clone.status = status;
        messages.push(clone);
        found = true;
      } else {
        messages.push(this._messages[i]);
      }
    }

    if (found === true) {
      this.setMessages(messages);
    }
  }

  setMessages(messages) {
    this._messages = messages;

    // append the message
    this.setState({
      messages: messages,
    });
  }

  handleSend(message = {}) {
    // Your logic here
    // Send message.text to your server
    
    if (this.state.client) {
      this.state.channel.sendMessage(message.text)
      .catch((error) => console.error(error))
    } else {
      this.initializeMessenging(message.text)
      message.uniqueId = Math.round(Math.random() * 10000); // simulating server-side unique id generation
      this.setMessages(this._messages.concat(message));  
      this.botMessage("Hello " + message.text + "!", 1000)
      .then(() => this.botMessage(BOT_CONFIRMATIONS[Math.floor(Math.random()*BOT_CONFIRMATIONS.length)], 2000))
    }
    
    // message.uniqueId = Math.round(Math.random() * 10000); // simulating server-side unique id generation
    // this.setMessages(this._messages.concat(message));

    // mark the sent message as Seen
    // setTimeout(() => {
    //   this.setMessageStatus(message.uniqueId, 'Seen'); // here you can replace 'Seen' by any string you want
    // }, 1000);

    // if you couldn't send the message to your server :
    // this.setMessageStatus(message.uniqueId, 'ErrorButton');
  }

  onLoadEarlierMessages() {

    // display a loader until you retrieve the messages from your server
    this.setState({
      isLoadingEarlierMessages: true,
    });

    // Your logic here
    // Eg: Retrieve old messages from your server

    // IMPORTANT
    // Oldest messages have to be at the begining of the array
    var earlierMessages = [
      {
        text: 'React Native enables you to build world-class application experiences on native platforms using a consistent developer experience based on JavaScript and React. https://github.com/facebook/react-native',
        name: 'React-Bot',
        image: {uri: 'https://facebook.github.io/react/img/logo_og.png'},
        position: 'left',
        date: new Date(2016, 0, 1, 20, 0),
        uniqueId: Math.round(Math.random() * 10000), // simulating server-side unique id generation
      }, {
        text: 'This is a touchable phone number 0606060606 parsed by taskrabbit/react-native-parsed-text',
        name: 'Awesome Developer',
        image: null,
        position: 'right',
        date: new Date(2016, 0, 2, 12, 0),
        uniqueId: Math.round(Math.random() * 10000), // simulating server-side unique id generation
      },
    ];

    setTimeout(() => {
      this.setMessages(earlierMessages.concat(this._messages)); // prepend the earlier messages to your list
      this.setState({
        isLoadingEarlierMessages: false, // hide the loader
        allLoaded: true, // hide the `Load earlier messages` button
      });
    }, 1000); // simulating network

  }

  handleReceive(message = {}) {
    // make sure that your message contains :
    // text, name, image, position: 'left', date, uniqueId
    this.setMessages(this._messages.concat(message));
  }

  onErrorButtonPress(message = {}) {
    // Your logic here
    // re-send the failed message

    // remove the status
    this.setMessageStatus(message.uniqueId, '');
  }

  // will be triggered when the Image of a row is touched
  onImagePress(message = {}) {
    // Your logic here
    // Eg: Navigate to the user profile
  }

  render() {
    return (
      <GiftedMessenger
        ref={(c) => this._GiftedMessenger = c}

        styles={{
          bubbleRight: {
            marginLeft: 70,
            backgroundColor: '#007aff',
          },
        }}

        autoFocus={false}
        messages={this.state.messages}
        handleSend={this.handleSend.bind(this)}
        onErrorButtonPress={this.onErrorButtonPress.bind(this)}
        maxHeight={Dimensions.get('window').height - Navigator.NavigationBar.Styles.General.NavBarHeight - STATUS_BAR_HEIGHT}

        loadEarlierMessagesButton={!this.state.allLoaded}
        onLoadEarlierMessages={this.onLoadEarlierMessages.bind(this)}

        senderName='Awesome Developer'
        senderImage={null}
        onImagePress={this.onImagePress}
        displayNames={true}
        
        onChangeText={() => this.state.channel ? this.state.channel.typing() : false}

        parseText={true} // enable handlePhonePress, handleUrlPress and handleEmailPress
        handlePhonePress={this.handlePhonePress}
        handleUrlPress={this.handleUrlPress}
        handleEmailPress={this.handleEmailPress}

        isLoadingEarlierMessages={this.state.isLoadingEarlierMessages}

        typingMessage={this.state.typingMessage}
      />
    );
  }

  handleUrlPress(url) {
    Linking.openURL(url);
  }

  // TODO
  // make this compatible with Android
  handlePhonePress(phone) {
    if (Platform.OS !== 'android') {
      var BUTTONS = [
        'Text message',
        'Call',
        'Cancel',
      ];
      var CANCEL_INDEX = 2;

      ActionSheetIOS.showActionSheetWithOptions({
        options: BUTTONS,
        cancelButtonIndex: CANCEL_INDEX
      },
      (buttonIndex) => {
        switch (buttonIndex) {
          case 0:
            Communications.phonecall(phone, true);
            break;
          case 1:
            Communications.text(phone);
            break;
        }
      });
    }
  }

  handleEmailPress(email) {
    Communications.email(email, null, null, null, null);
  }

}


module.exports = GiftedMessengerContainer;
