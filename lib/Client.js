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

import {
  ChannelPaginator,
} from './Paginators';

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
    this.onSynchronizationStatusChanged = null;
    this.onChannelAdded = null;
    this.onChannelChanged = null;
    this.onChannelDeleted = null;
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

    if (synchronizationStrategy || initialMessageCount) {
      this._properties = {
        synchronizationStrategy,
        initialMessageCount,
      };
    }

    // event handlers
    this._synchronizationStatusChangedSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:synchronizationStatusChanged',
      (status) => {
        this.synchronizationStatus = status;
        if (status === Constants.TWMClientSynchronizationStatus.Completed) {
          TwilioChatClient.userInfo()
          .then((userInfo) => { this.userInfo = new UserInfo(userInfo); })
          .then(() => {
            if (Platform.OS === 'android') {
              return TwilioChatChannels.getChannels();
            }
            return true;
          })
          .then(() => {
            if (this.onClientSynchronized) this.onClientSynchronized();
          });
        }
        if (this.onSynchronizationStatusChanged) this.onSynchronizationStatusChanged(status);
      },
    );

    this._channelAddedSubscription = NativeAppEventEmitter.addListener(
        'ipMessagingClient:channelAdded',
        (channel) => {
          if (this.onChannelAdded) this.onChannelAdded(new Channel(channel));
        },
    );

    this._channelChangedSubscription = NativeAppEventEmitter.addListener(
        'ipMessagingClient:channelChanged',
        (channel) => {
          if (this.onChannelChanged) this.onChannelChanged(new Channel(channel));
        },
    );

    this._channelDeletedSubscription = NativeAppEventEmitter.addListener(
        'ipMessagingClient:channelDeleted',
        (channel) => {
          if (this.onChannelDeleted) this.onChannelDeleted(new Channel(channel));
        },
    );

    this._channelSynchronizationStatusChangedSubscription = NativeAppEventEmitter.addListener(
        'ipMessagingClient:channel:synchronizationStatusChanged',
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
      'ipMessagingClient:channel:memberJoined',
      ({ channelSid, member }) => {
        if (this.onMemberJoined) this.onMemberJoined({ channelSid, member: new Member(member) });
      },
    );

    this._channelMemberChangedSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:channel:memberChanged',
      ({ channelSid, member }) => {
        if (this.onMemberChanged) this.onMemberChanged({channelSid, member: new Member(member) });
      },
    );

    this._channelMemberLeftSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:channel:memberLeft',
      ({ channelSid, member }) => {
        if (this.onMemberLeft) this.onMemberLeft({ channelSid, member: new Member(member) });
      },
    );

    this._channelMessageAddedSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:channel:messageAdded',
      ({ channelSid, message }) => {
        if (this.onMessageAdded) {
          this.onMessageAdded({ channelSid, message: new Message(message, channelSid) });
        }
      },
    );

    this._channelMessageChangedSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:channel:messageChanged',
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
      'ipMessagingClient:channel:messageDeleted',
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
      'ipMessagingClient:errorReceived',
      ({ error, userInfo }) => {
        if (this.onError) this.onError({ error, userInfo });
      },
    );

    this._typingChannelStartedSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:typingStartedOnChannel',
      ({ channelSid, member }) => {
        if (this.onTypingStarted) this.onTypingStarted({ channelSid, member: new Member(member) });
      },
    );

    this._typingChannelEndedSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:typingEndedOnChannel',
      ({ channelSid, member }) => {
        if (this.onTypingEnded) this.onTypingEnded({ channelSid, member: new Member(member) });
      },
    );

    this._toastSubscribedSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:toastSubscribed',
      () => {
        if (this.onToastSubscribed) this.onToastSubscribed();
      },
    );

    this._toastReceivedChannelSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:toastReceived',
      ({ channelSid, messageSid }) => {
        if (this.onToastReceived) this.onToastReceived({ channelSid, messageSid });
      },
    );

    this._toastRegistrationFailedSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:toastFailed',
      ({ error, userInfo }) => {
        if (this.onToastFailed) this.onToastFailed({ error, userInfo });
      },
    );

    this._userInfoUpdatedSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:userInfoUpdated',
      ({ updated, userInfo }) => {
        this.userInfo = new UserInfo(userInfo);
        if (this.onUserInfoUpdated) this.onUserInfoUpdated({ updated, userInfo: this.userInfo });
      },
    );

    this._channelMemberUserInfoUpdatedSubscription = NativeAppEventEmitter.addListener(
      'ipMessagingClient:channel:member:userInfoUpdated',
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
    .then(({ sid, paginator }) => new ChannelPaginator(sid, paginator));
  }

  getPublicChannels() {
    return TwilioChatChannels.getPublicChannels()
    .then(({ sid, paginator }) => new ChannelPaginator(sid, paginator));
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
          newKey = Constants.TWMChannelOption.FriendlyName;
          break;
        case 'uniqueName':
          newKey = Constants.TWMChannelOption.UniqueName;
          break;
        case 'type':
          newKey = Constants.TWMChannelOption.Type;
          break;
        case 'attributes':
          newKey = Constants.TWMChannelOption.Attributes;
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
    this._removeListeners();
    this.accessManager.removeListeners();
  }

  _removeListeners() {
    this._synchronizationStatusChangedSubscription.remove();
    this._channelAddedSubscription.remove();
    this._channelChangedSubscription.remove();
    this._channelDeletedSubscription.remove();
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
