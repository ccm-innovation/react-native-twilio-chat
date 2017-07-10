import { NativeModules, NativeAppEventEmitter, Platform } from 'react-native';

const {
  TwilioChatChannels,
  TwilioChatMessages,
  TwilioChatMembers
} = NativeModules;

class ChannelDescriptor {
  constructor(props) {
    this.sid = props.sid;
    this.friendlyName = props.friendlyName;
    this.uniqueName = props.uniqueName;
    this.attributes = props.attributes;
    this.dateCreated = new Date(props.dateCreated);
    this.dateUpdated = new Date(props.dateUpdated);
    this.createdBy = props.createdBy;
    if (props.membersCount) this.membersCount = props.membersCount;
    if (props.messagesCount) this.messageCount = props.messagesCount;
  }

  async getChannel() {
    return await TwilioChatChannels.getChannel(this.sid);
  }
}

export default ChannelDescriptor;
