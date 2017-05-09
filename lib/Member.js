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

  userDescriptor() {
    return TwilioChatMembers.userDescriptor(this.channelSid, this.identity);
  }

  subscribedUser() {
    return TwilioChatMembers.subscribedUser(this.channelSid, this.identity);
  }
}

export default Member;
