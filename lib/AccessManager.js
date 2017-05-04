import {
    NativeModules,
    NativeAppEventEmitter,
    Platform
} from 'react-native';

const { TwilioAccessManager } = NativeModules;

function parseManager(manager) {
  if (manager) {
    this.token = manager.token;
    this.expires = new Date(manager.expirationDate);
  }
  return true;
}

class AccessManager {
  constructor(token) {
    this.token = token;

    this.onTokenExpired = null;
    this.onTokenWillExpire = null;
    this.onTokenInvalid = null;

    this._accessManagerTokenInvalidSubscription = NativeAppEventEmitter.addListener(
      'accessManager:tokenInvalid',
      (error) => {
        if (this.onTokenInvalid) this.onTokenInvalid(error);
      },
    );

    this._accessManagerTokenWillExpireSubscription = NativeAppEventEmitter.addListener(
      'accessManager:tokenWillExpire',
      (error) => {
        if (this.onTokenWillExpire) this.onTokenWillExpire(error);
      },
    );

    this._accessManagerTokenExpiredSubscription = NativeAppEventEmitter.addListener(
        'accessManager:tokenExpired',
        () => {
          if (this.onTokenExpired) this.onTokenExpired();
        },
    );

    TwilioAccessManager.accessManagerWithToken(this.token)
    .then(parseManager.bind(this));
  }

  registerClient() {
    if (Platform.OS === 'ios') {
      TwilioAccessManager.registerClient();
    }
  }

  updateToken(newToken) {
    TwilioAccessManager.updateToken(newToken)
    .then(parseManager.bind(this));
  }

  removeListeners() {
    this._accessManagerTokenInvalidSubscription.remove();
    this._accessManagerTokenExpiredSubscription.remove();
    this._accessManagerTokenWillExpireSubscription.remove();
  }
}

export default AccessManager;
