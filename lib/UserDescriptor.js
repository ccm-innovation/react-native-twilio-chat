import {
  NativeModules,
  NativeAppEventEmitter
} from 'react-native';
const {
  TwilioChatClient
} = NativeModules;
class UserDescriptor {
  constructor(props) {
    this.identity = props.identity;
    this.friendlyName = props.friendlyName;
    this.attributes = props.attributes;
    this.isOnline = props.isOnline;
    this.isNotifiable = props.isNotifiable;
  }

  subscribe() {
    // TODO: Implement this method
  }

}
export default UserDescriptor
