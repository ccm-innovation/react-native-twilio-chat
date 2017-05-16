import React, { Component } from "react";

import { Dimensions, Linking, Platform, View } from "react-native";

import { GiftedChat } from "react-native-gifted-chat";

import { AccessManager, Client, Constants } from "react-native-twilio-chat";

const BOT_GREETINGS = [
  "Hello!",
  "Good day, mate!",
  "Why hello there!",
  "Hola!",
  "Bonjour",
  "I'm booting up...",
  "Hiya!",
  "Heellllooooooooooooooo",
];

const BOT_QUESTIONS = [
  "Let's be friends! What can I call you?",
  "I'm your new pal! What's your name?",
  "I am here to serve, how shall I address you?",
  "You're my new friend! What is your preferred name?",
  "Let me update my records... what is your name?",
  "I'll help you get things started. What is your name?",
];

const BOT_CONFIRMATIONS = [
  'You are now cleared to chat!',
  'Feel free to chat with the group',
  'I have now connected you to the channel',
  'Chat away!',
  'Feel free to start chatting',
  'The group awaits your input',
  'Go for the gold!',
];

let STATUS_BAR_HEIGHT = 0;

if (Platform.OS === 'android') {
  // const ExtraDimensions = require('react-native-extra-dimensions-android');
  STATUS_BAR_HEIGHT = 50;
}

export default class Chat extends Component {

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
    return fetch(`http://localhost:3001/token/${identity}`, {
      method: 'post',
    })
      .then(res => res.json());
  }

  parseMessage(message) {
    return {
      _id: message.sid,
      text: message.body,
      user: message.author,
      position: message.author === this.state.client.user.identity ? 'right' : 'left',
      date: message.timestamp,
    };
  }

  initializeMessenging(identity) {
    console.log('starting init');
    this.getToken(identity)
      .then(({ token }) => {
        // initaite new Access Manager
        const accessManager = new AccessManager(token);

        accessManager.onTokenWillExpire = () => {
          this.getToken(identity)
            .then(newToken => accessManager.updateToken(newToken.token));
        };

        accessManager.onTokenInvalid = () => {
          console.log('Token is invalid');
        };

        accessManager.onTokenExpired = () => {
          console.log('Token is expired');
        };

        // initiate the client with the token, not accessManager
        const client = new Client(token);

        client.onError = ({ error, user }) => {
          console.log(error);
          console.log(user);
        };

        client.onSynchronizationStatusChanged = (status) => {
          console.log(status);
        };

        client.onClientConnectionStateChanged = (state) => {
          console.log(state);
        };

        client.onClientSynchronized = () => {
          console.log('client synced');
          client.getPublicChannels()
            .then(res => console.log(res));

          client.getChannel('general')
            .then((channel) => {
              console.log(channel);
              if (channel.status !== Constants.TCHChannelStatus.Joined) {
                channel.join();
              }

              channel.onTypingStarted = (member) => {
                this.setState({ typingMessage: `${member.user.identity} is typing...` });
              };

              channel.onTypingEnded = () => {
                this.setState({ typingMessage: '' });
              };

              channel.onMessageAdded = message => this.handleReceive(this.parseMessage(message));

              this.setState({ client, channel, accessManager });

              channel.getMessages()
                .then((messages) => {
                  messages.forEach((message) => this.handleReceive(this.parseMessage(message)));
                })

            });
        };

        client.initialize()
          .then(() => {
            console.log(client);
            console.log('client initilized');
            // register the client with the accessManager
            accessManager.registerClient();
          });
      });
  }

  botMessage(message, time = 1000) {
    this.setState({ typingMessage: 'MessagingBot is typing...' });
    return new Promise((resolve) => {
      setTimeout(() => {
        this.setState({ typingMessage: '' });
        this.handleReceive({
          text: message,
          _id: Math.round(Math.random() * 10000),
          user: 'MessagingBot',
          position: 'left',
          internal: true,
        });
        resolve();
      }, time);
    });
  }

  componentDidMount() {
    setTimeout(() => {
          this.botMessage(BOT_GREETINGS[Math.floor(Math.random() * BOT_GREETINGS.length)])
          .then(() => this.botMessage(BOT_QUESTIONS[Math.floor(Math.random() * BOT_QUESTIONS.length)], 2000));
        }, 500);
    this.initializeMessenging('Brad');
  }

  componentWillUnmount() {
    this._isMounted = false;
  }

  getInitialMessages() {
    return [];
  }

  setMessageStatus(_id, status) {
    const messages = [];
    let found = false;

    for (let i = 0; i < this._messages.length; i++) {
      if (this._messages[i]._id === _id) {
        const clone = Object.assign({}, this._messages[i]);
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
      messages,
    });
  }

  handleSend(message = {}) {
    if (this.state.client) {
      this.state.channel.sendMessage(message.text)
        .catch(error => console.error(error));
    } else {
      this.initializeMessenging(message.text);
      message._id = Math.round(Math.random() * 10000); // simulating server-side unique id generation
      this.setMessages(this._messages.concat(message));
      this.botMessage(`Hello ${message.text}!`, 1000)
        .then(() => this.botMessage(BOT_CONFIRMATIONS[Math.floor(Math.random() * BOT_CONFIRMATIONS.length)], 2000));
    }
  }

  handleReceive(message = {}) {
    // make sure that your message contains :
    // text, name, image, position: 'left', date, _id
    this.setMessages([message, ...this._messages]);
  }

  onErrorButtonPress(message = {}) {
    // Your logic here
    // re-send the failed message

    // remove the status
    this.setMessageStatus(message._id, '');
  }

  render() {
    return (
      <View style={{flex: 1, borderWidth: 1}}>
        <GiftedChat
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
          // maxHeight={Dimensions.get('window').height}

          loadEarlierMessagesButton={false}

          senderName="Awesome Developer"
          senderImage={null}
          onImagePress={this.onImagePress}
          displayNames

          onChangeText={() => this.state.channel ? this.state.channel.typing() : false}

          parseText // enable handlePhonePress, handleUrlPress and handleEmailPress
          handlePhonePress={this.handlePhonePress}
          handleUrlPress={this.handleUrlPress}
          handleEmailPress={this.handleEmailPress}

          isLoadingEarlierMessages={this.state.isLoadingEarlierMessages}
          typingMessage={this.state.typingMessage}
        />
      </View>
    );
  }

  handleUrlPress(url) {
    Linking.openURL(url);
  }

}
