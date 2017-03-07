import {
  NativeModules,
  NativeAppEventEmitter,
} from 'react-native';

const {
  TwilioChatClient,
} = NativeModules;

class UserInfo {
  constructor(props) {
    this.identity = props.identity;
    this.friendlyName = props.friendlyName;
    this.attributes = props.attributes;
    this.isOnline = props.isOnline;
    this.isNotifiable = props.isNotifiable;

    this.onUpdate = null;

    // event handlers
    this._userInfoUpdateSubscription = NativeAppEventEmitter.addListener(
      'chatClient:userInfoUpdated',
      ({ updated, userInfo }) => {
        if (userInfo.identity === this.identity) {
          this.friendlyName = userInfo.friendlyName;
          this.attributes = userInfo.attributes;
          this.isOnline = userInfo.isOnline;
          this.isNotifiable = userInfo.isNotifiable;
          if (this.onUpdate) this.onUpdate(updated);
        }
      },
    );
  }

  setAttributes(attributes) {
    return TwilioChatClient.setAttributes(attributes);
  }

  setFriendlyName(friendlyName) {
    return TwilioChatClient.setFriendlyName(friendlyName);
  }

  close() {
    this._userInfoUpdateSubscription.remove();
  }
}

export default UserInfo;
