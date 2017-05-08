import {
  NativeModules,
  NativeAppEventEmitter,
} from 'react-native';

const {
  TwilioChatClient,
} = NativeModules;

class User {
  constructor(props) {
    this.identity = props.identity;
    this.friendlyName = props.friendlyName;
    this.attributes = props.attributes;
    this.isOnline = props.isOnline;
    this.isNotifiable = props.isNotifiable;

    this.onUpdate = null;

    // event handlers
    this._userUpdateSubscription = NativeAppEventEmitter.addListener(
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
    this._userUpdateSubscription.remove();
  }
}

export default User;
