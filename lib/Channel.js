import {
  NativeModules,
  NativeAppEventEmitter,
  Platform,
} from 'react-native';

import Message from './Message';
import Member from './Member';
import UserInfo from './UserInfo';
import Paginator from './Paginator';

const {
    TwilioChatChannels,
    TwilioChatMessages,
    TwilioChatMembers,
} = NativeModules;

class Channel {
  constructor(props) {
    this.sid = props.sid;
    this.friendlyName = props.friendlyName;
    this.uniqueName = props.uniqueName;
    if (props.synchronizationStatus) this.synchronizationStatus = props.synchronizationStatus;
    if (props.status) this.status = props.status;
    if (props.type) this.type = props.type;
    this.attributes = props.attributes;
    this.dateCreated = new Date(props.dateCreated);
    this.dateUpdated = new Date(props.dateUpdated);
    this.createdBy = props.createdBy;
    if (props.membersCount) this.membersCount = props.membersCount;
    if (props.messagesCount) this.messageCount = props.messagesCount;

    this.onSynchronizationStatusChanged = null;
    this.onChanged = null;
    this.onDeleted = null;
    this.onMemberJoined = null;
    this.onMemberChanged = null;
    this.onMemberLeft = null;
    this.onMemberUserInfoUpdated = null;
    this.onMessageAdded = null;
    this.onMessageChanged = null;
    this.onMessageDeleted = null;
    this.onTypingStarted = null;
    this.onTypingEnded = null;
    this.onToastReceived = null;

    // event handlers
    this._channelSynchronizationStatusChangedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:synchronizationStatusChanged',
      ({ channelSid, status }) => {
        if (channelSid === this.sid && this.onSynchronizationStatusChanged) this.onSynchronizationStatusChanged(status);
      },
    );

    this._channelChangedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channelChanged',
      (channel) => {
        if (channel.sid === this.sid && this.onChanged) {
          this.sid = channel.sid;
          this.friendlyName = channel.friendlyName;
          this.uniqueName = channel.uniqueName;
          this.synchronizationStatus = channel.synchronizationStatus;
          this.status = channel.status;
          this.type = channel.type;
          this.attributes = channel.attributes;
          this.dateCreated = new Date(channel.dateCreated);
          this.dateUpdated = new Date(channel.dateUpdated);
          this.createdBy = props.createdBy;
          this.onChanged();
        }
      },
    );

    this._channelDeletedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channelDeleted',
      (channel) => {
        if (channel.sid === this.sid && this.onDeleted) this.onDeleted();
      },
    );

    this._channelMemberJoinedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:memberJoined',
      ({ channelSid, member }) => {
        if (channelSid === this.sid && this.onMemberJoined) this.onMemberJoined(new Member(member));
      },
    );

    this._channelMemberChangedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:memberChanged',
      ({ channelSid, member }) => {
        if (channelSid === this.sid && this.onMemberChanged) this.onMemberChanged(new Member(member));
      },
    );

    this._channelMemberLeftSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:memberLeft',
      ({ channelSid, member }) => {
        if (channelSid === this.sid && this.onMemberLeft) this.onMemberLeft(new Member(member));
      },
    );

    this._channelMessageAddedSubscription = NativeAppEventEmitter.addListener(
        'chatClient:channel:messageAdded',
        ({ channelSid, message }) => {
          if (channelSid === this.sid && this.onMessageAdded) this.onMessageAdded(new Message(message, channelSid));
        },
    );

    this._channelMessageChangedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:messageChanged',
      ({ channelSid, message }) => {
        if (channelSid === this.sid && this.onMessageChanged) this.onMessageChanged(new Message(message, channelSid));
      },
    );

    this._channelMessageDeletedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:messageDeleted',
      ({ channelSid, message }) => {
        if (channelSid === this.sid && this.onMessageDeleted) this.onMessageDeleted(new Message(message, channelSid));
      },
    );

    this._typingChannelStartedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:typingStartedOnChannel',
      ({ channelSid, member }) => {
        if (channelSid === this.sid && this.onTypingStarted) this.onTypingStarted(new Member(member));
      },
    );

    this._typingChannelEndedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:typingEndedOnChannel',
      ({ channelSid, member }) => {
        if (channelSid === this.sid && this.onTypingEnded) this.onTypingEnded(new Member(member));
      },
    );

    this._toastReceivedChannelSubscription = NativeAppEventEmitter.addListener(
      'chatClient:toastReceivedOnChannel',
      ({ channelSid, message }) => {
        if (channelSid === this.sid && this.onToastReceived) this.onToastReceived(new Message(message));
      },
    );

    this._memberUserInfoUpdatedSubscription = NativeAppEventEmitter.addListener(
      'chatClient:channel:member:userInfoUpdated',
      ({ channelSid, updated, userInfo }) => {
          if (channelSid === this.sid && this.onMemberUserInfoUpdated) this.onMemberUserInfoUpdated({ updated, userInfo: new UserInfo(userInfo) });
      },
    );
  }

  initialize() {
    return TwilioChatChannels.synchronize(this.sid);
  }

  setAttributes(attributes) {
    this.attributes = attributes;
    return TwilioChatChannels.setAttributes(this.sid, attributes);
  }

  setFriendlyName(friendlyName) {
    this.friendlyName = friendlyName;
    return TwilioChatChannels.setFriendlyName(this.sid, friendlyName);
  }

  setUniqueName(uniqueName) {
    this.uniqueName = uniqueName;
    return TwilioChatChannels.setUniqueName(this.sid, uniqueName);
  }

  join() {
    return TwilioChatChannels.join(this.sid);
  }

  declineInvitation() {
    return TwilioChatChannels.declineInvitation(this.sid);
  }

  leave() {
    return TwilioChatChannels.leave(this.sid);
  }

  destroy() {
    return TwilioChatChannels.destroy(this.sid);
  }

  typing() {
    TwilioChatChannels.typing(this.sid);
  }

  getMember(identity) {
    return TwilioChatChannels.getMember(this.sid, identity)
    .then(member => new Member(member));
  }

  getMembers() {
    return TwilioChatMembers.getMembers(this.sid)
    .then(({ sid, type, paginator }) => new Paginator(sid, type, paginator));
  }

  add(identity) {
    return TwilioChatMembers.add(this.sid, identity);
  }

  invite(identity) {
    return TwilioChatMembers.invite(this.sid, identity);
  }

  remove(identity) {
    return TwilioChatMembers.remove(this.sid, identity);
  }

  getLastConsumedMessageIndex() {
    return TwilioChatMessages.getLastConsumedMessageIndex(this.sid);
  }

  sendMessage(body, attributes = null) {
    return TwilioChatMessages.sendMessage(this.sid, body, attributes);
  }

  removeMessage(index) {
    return TwilioChatMessages.removeMessage(this.sid, index);
  }

  getMessages(count = 10) {
    return TwilioChatMessages.getLastMessages(this.sid, count)
    .then(messages => messages.map(message => new Message(message, this.sid)));
  }

  getMessagesBefore(index, count) {
    return TwilioChatMessages.getMessagesBefore(this.sid, index, count)
    .then(messages => messages.map(message => new Message(message, this.sid)));
  }

  getMessagesAfter(index, count) {
    return TwilioChatMessages.getMessagesAfter(this.sid, index, count)
    .then(messages => messages.map(message => new Message(message, this.sid)));
  }

  getMessage(index) {
    return TwilioChatMessages.getMessage(this.sid, index)
    .then(message => new Message(message, this.sid));
  }

  getMessageForConsumption(index) {
    if (Platform.OS !== 'ios') console.warn('getMessageForConsumption is only available on iOS.');
    else {
      return TwilioChatMessages.messageForConsumptionIndex(this.sid, index)
      .then(message => new Message(message, this.sid));
    }
  }

  setLastConsumedMessageIndex(index) {
    TwilioChatMessages.setLastConsumedMessageIndex(this.sid, index);
  }

  advanceLastConsumedMessageIndex(index) {
    TwilioChatMessages.advanceLastConsumedMessageIndex(this.sid, index);
  }

  setAllMessagesConsumed() {
    TwilioChatMessages.setAllMessagesConsumed(this.sid);
  }

  getUnconsumedMessagesCount() {
    return TwilioChatChannels.getUnconsumedMessagesCount(this.sid);
  }

  getMessagesCount() {
    return TwilioChatChannels.getMessagesCount(this.sid);
  }

  getMembersCount() {
    return TwilioChatChannels.getMembersCount(this.sid);
  }

  close() {
    this._channelChangedSubscription.remove();
    this._channelDeletedSubscription.remove();
    this._channelSynchronizationStatusChangedSubscription.remove();
    this._channelMemberJoinedSubscription.remove();
    this._channelMemberChangedSubscription.remove();
    this._channelMemberLeftSubscription.remove();
    this._channelMessageAddedSubscription.remove();
    this._channelMessageChangedSubscription.remove();
    this._channelMessageDeletedSubscription.remove();
    this._typingChannelStartedSubscription.remove();
    this._typingChannelEndedSubscription.remove();
    this._toastReceivedChannelSubscription.remove();
    this._memberUserInfoUpdatedSubscription.remove();
  }
}

export default Channel;
