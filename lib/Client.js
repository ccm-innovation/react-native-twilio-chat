import {
  NativeModules,
  NativeAppEventEmitter,
  Platform,
} from 'react-native';

import Channel from './Channel';
import Member from './Member';
import Message from './Message';
import UserInfo from './UserInfo';
import Constants from './Constants';

import Paginator from './Paginator';

const {
  TwilioChatClient,
  TwilioChatChannels,
} = NativeModules;

class Client {
  constructor(initialToken, synchronizationStrategy, initialMessageCount) {
    // properties
    this.initialToken = initialToken;
    this.userInfo = {};
    this.isReachabilityEnabled = false;

    // initial event handlers
    this.onClientConnectionStateChanged = null;
    this.onSynchronizationStatusChanged = null;
    this.onChannelAdded = null;
    this.onChannelChanged = null;
    this.onChannelDeleted = null;
    this.onChannelInvited = null;
    this.onChannelSynchronizationStatusChanged = null;
    this.onMemberJoined = null;
    this.onMemberChanged = null;
    this.onMemberLeft = null;
    this.onMemberUserInfoUpdated = null;
    this.onMessageAdded = null;
    this.onMessageChanged = null;
    this.onMessageDeleted = null;
    this.onError = null;
    this.onTypingStarted = null;
    this.onTypingEnded = null;

    this.onToastSubscribed = null;
    this.onToastReceived = null;
    this.onToastFailed = null;

    this.onClientSynchronized = null;
    if (!synchronizationStrategy) {
      synchronizationStrategy = Constants.TCHClientSynchronizationStrategy.ChannelsList;
    }
    this._properties = {
      synchronizationStrategy,
      initialMessageCount: initialMessageCount ? initialMessageCount : 100,
    };

    // event handlers
    this._clientConnectionStateChangedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:connectionStateChanged',
      (state) => {
        if (this.onClientConnectionStateChanged) this.onClientConnectionStateChanged(state);
      },
    );


    this._synchronizationStatusChangedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:synchronizationStatusChanged',
      (status) => {
        this.synchronizationStatus = status;
        if (status === Constants.TCHClientSynchronizationStatus.Completed) {
          TwilioChatClient.userInfo()
          .then((userInfo) => { this.userInfo = new UserInfo(userInfo); })
          .then(() => {
            if (this.onClientSynchronized) this.onClientSynchronized();
          });
        }
        if (this.onSynchronizationStatusChanged) this.onSynchronizationStatusChanged(status);
      },
    );

    this._channelAddedSubscription = NativeAppEventEmitter.addListener(
        'chatClient:channelAdded',
        (channel) => {
          if (this.onChannelAdded) this.onChannelAdded(new Channel(channel));
        },
    );

    this._channelChangedSubscription = NativeAppEventEmitter.addListener(
        'chatClient:channelChanged',
        (channel) => {
          if (this.onChannelChanged) this.onChannelChanged(new Channel(channel));
        },
    );

    this._channelInvitedSubscription = NativeAppEventEmitter.addListener(
        'chatClient:channelInvited',
        (channel) => {
          if (this.onChannelInvited) this.onChannelInvited(new Channel(channel));
        },
    );


    this._channelDeletedSubscription = NativeAppEventEmitter.addListener(
        'chatClient:channelDeleted',
        (channel) => {
          if (this.onChannelDeleted) this.onChannelDeleted(new Channel(channel));
        },
    );

    this._channelSynchronizationStatusChangedSubscription = NativeAppEventEmitter.addListener(
        'chatClient:channel:synchronizationStatusChanged',
        ({ channelSid, status }) => {
          if (this.onChannelSynchronizationStatusChanged) {
            this.onChannelSynchronizationStatusChanged({
              channelSid,
              status,
            });
          }
        },
    );

    this._channelMemberJoinedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:memberJoined',
      ({ channelSid, member }) => {
        if (this.onMemberJoined) this.onMemberJoined({ channelSid, member: new Member(member) });
      },
    );

    this._channelMemberChangedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:memberChanged',
      ({ channelSid, member }) => {
        if (this.onMemberChanged) this.onMemberChanged({channelSid, member: new Member(member) });
      },
    );

    this._channelMemberLeftSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:memberLeft',
      ({ channelSid, member }) => {
        if (this.onMemberLeft) this.onMemberLeft({ channelSid, member: new Member(member) });
      },
    );

    this._channelMessageAddedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:messageAdded',
      ({ channelSid, message }) => {
        if (this.onMessageAdded) {
          this.onMessageAdded({ channelSid, message: new Message(message, channelSid) });
        }
      },
    );

    this._channelMessageChangedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:messageChanged',
      ({ channelSid, message }) => {
        if (this.onMessageChanged) {
          this.onMessageChanged({
            channelSid,
            message: new Message(message, channelSid),
          });
        }
      },
    );

    this._channelMessageDeletedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:messageDeleted',
      ({ channelSid, message }) => {
        if (this.onMessageDeleted) {
          this.onMessageDeleted({
            channelSid,
            message: new Message(message, channelSid),
          });
        }
      },
    );

    this._ErrorReceivedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:errorReceived',
      ({ error, userInfo }) => {
        if (this.onError) this.onError({ error, userInfo });
      },
    );

    this._typingChannelStartedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:typingStartedOnChannel',
      ({ channelSid, member }) => {
        if (this.onTypingStarted) this.onTypingStarted({ channelSid, member: new Member(member) });
      },
    );

    this._typingChannelEndedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:typingEndedOnChannel',
      ({ channelSid, member }) => {
        if (this.onTypingEnded) this.onTypingEnded({ channelSid, member: new Member(member) });
      },
    );

    this._toastSubscribedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:toastSubscribed',
      () => {
        if (this.onToastSubscribed) this.onToastSubscribed();
      },
    );

    this._toastReceivedChannelSubscription = NativeAppEventEmitter.addListener(
      'chatClient:toastReceived',
      ({ channelSid, messageSid }) => {
        if (this.onToastReceived) this.onToastReceived({ channelSid, messageSid });
      },
    );

    this._toastRegistrationFailedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:toastFailed',
      ({ error, userInfo }) => {
        if (this.onToastFailed) this.onToastFailed({ error, userInfo });
      },
    );

    this._userInfoUpdatedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:userInfoUpdated',
      ({ updated, userInfo }) => {
        this.userInfo = new UserInfo(userInfo);
        if (this.onUserInfoUpdated) this.onUserInfoUpdated({ updated, userInfo: this.userInfo });
      },
    );

    this._channelMemberUserInfoUpdatedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:member:userInfoUpdated',
      ({ channelSid, updated, userInfo }) => {
        if (this.onMemberUserInfoUpdated) {
          this.onMemberUserInfoUpdated({ channelSid, updated, userInfo: new UserInfo(userInfo) });
        }
      },
    );
  }

  initialize() {
    return TwilioChatClient.createClient(this.initialToken, this._properties)
    .then((client) => {
      if (client) {
        this.version = client.version;
        this.synchronizationStatus = client.synchronizationStatus;
        this.isReachabilityEnabled = client.isReachabilityEnabled;
      }
      return true;
    });
  }

  getUserChannels() {
    return TwilioChatChannels.getUserChannels()
    .then(({ sid, type, paginator }) => new Paginator(sid, type, paginator));
  }

  getPublicChannels() {
    return TwilioChatChannels.getPublicChannels()
    .then(({ sid, type, paginator }) => new Paginator(sid, type, paginator));
  }

  getChannel(sidOrUniqueName) {
    return TwilioChatChannels.getChannel(sidOrUniqueName)
    .then(channel => new Channel(channel));
  }

  createChannel(options) {
    const parsedOptions = {};
    for (const key in options) {
      let newKey = null;
      switch(key) {
        case 'friendlyName':
          newKey = Constants.TCHChannelOption.FriendlyName;
          break;
        case 'uniqueName':
          newKey = Constants.TCHChannelOption.UniqueName;
          break;
        case 'type':
          newKey = Constants.TCHChannelOption.Type;
          break;
        case 'attributes':
          newKey = Constants.TCHChannelOption.Attributes;
          break;
      }
      parsedOptions[newKey] = options[key];
    }
    return TwilioChatChannels.createChannel(parsedOptions)
    .then(channel => new Channel(channel));
  }

  setLogLevel(logLevel) {
    TwilioChatClient.setLogLevel(logLevel);
  }

  register(token) {
    TwilioChatClient.register(token);
  }

  unregister(token) {
    TwilioChatClient.unregister(token);
  }

  handleNotification(notification) {
    TwilioChatClient.handleNotification(notification);
  }

  shutdown() {
    TwilioChatClient.shutdown();
    if (Platform.OS === 'android') {
      TwilioChatChannels.shutdown();
    }
    this._removeListeners();
  }

  _removeListeners() {
    this._clientConnectionStateChangedSubscription.remove()
    this._synchronizationStatusChangedSubscription.remove();
    this._channelAddedSubscription.remove();
    this._channelChangedSubscription.remove();
    this._channelDeletedSubscription.remove();
    this._channelInvitedSubscription.remove();
    this._channelSynchronizationStatusChangedSubscription.remove();
    this._channelMemberJoinedSubscription.remove();
    this._channelMemberChangedSubscription.remove();
    this._channelMemberLeftSubscription.remove();
    this._channelMessageAddedSubscription.remove();
    this._channelMessageChangedSubscription.remove();
    this._channelMessageDeletedSubscription.remove();
    this._ErrorReceivedSubscription.remove();
    this._typingChannelStartedSubscription.remove();
    this._typingChannelEndedSubscription.remove();
    this._toastSubscribedSubscription.remove();
    this._toastReceivedChannelSubscription.remove();
    this._toastRegistrationFailedSubscription.remove();
    this._userInfoUpdatedSubscription.remove();
    this._channelMemberUserInfoUpdatedSubscription.remove();
  }
}

export default Client;
