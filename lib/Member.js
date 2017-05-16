import {
  NativeModules,
  NativeAppEventEmitter,
  Platform,
} from 'react-native';

const {
  TwilioChatMembers,
} = NativeModules;

class Member {
  constructor(props, channelSid) {
    this.identity = props.identity;
    this.channelSid = channelSid;
    this.lastConsumedMessageIndex = props.lastConsumedMessageIndex;
    this.lastConsumptionTimestamp = this.lastConsumptionTimestamp ? new Date(this.lastConsumptionTimestamp) : null;
  }

  getUserDescriptor() {
    return TwilioChatMembers.userDescriptor(this.channelSid, this.identity);
  }

  getAndSubscribeUser() {
    return TwilioChatMembers.subscribedUser(this.channelSid, this.identity);
  }
}

export default Member;
