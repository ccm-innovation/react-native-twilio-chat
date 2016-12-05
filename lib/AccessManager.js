import {
    NativeModules,
    NativeAppEventEmitter,
} from 'react-native';

const { TwilioAccessManager } = NativeModules;

function parseManager(manager) {
  if (manager) {
    this.identity = manager.identity;
    this.token = manager.token;
    this.isExpired = manager.isExpired;
    this.expires = new Date(manager.expirationDate);
  }
  return true;
}

class AccessManager {
  constructor(token) {
    this.token = token;

    this.onTokenExpired = null;
    this.onError = null;

    this._accessManagerErrorSubscription = NativeAppEventEmitter.addListener(
      'accessManager:error',
      (error) => {
        if (this.onError) this.onError(error);
      },
    );

    this._accessManagerTokenExpirationSubscription = NativeAppEventEmitter.addListener(
        'accessManager:tokenExpired',
        () => {
          if (this.onTokenExpired) this.onTokenExpired();
        },
    );
  }

  initialize() {
    return TwilioAccessManager.accessManagerWithToken(this.token)
    .then(parseManager.bind(this));
  }

  updateToken(newToken) {
    TwilioAccessManager.updateToken(newToken)
    .then(parseManager.bind(this));
  }

  removeListeners() {
    this._accessManagerErrorSubscription.remove();
    this._accessManagerTokenExpirationSubscription.remove();
  }
}

export default AccessManager;
