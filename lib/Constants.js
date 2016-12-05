import React, {
  NativeModules,
  Platform,
} from 'react-native';

const {
  TwilioChatClient,
} = NativeModules;

function getConstants() {
  if (Platform.OS === 'android') {
    return {
      TWMChannelStatus: TwilioChatClient.TWMChannelStatus,
      TWMChannelSynchronizationStatus: TwilioChatClient.TWMChannelSynchronizationStatus,
      TWMChannelType: TwilioChatClient.TWMChannelType,
      TWMChannelOption: TwilioChatClient.TWMChannelOption,
      TWMClientSynchronizationStatus: TwilioChatClient.TWMClientSynchronizationStatus,
      TWMClientSynchronizationStrategy: TwilioChatClient.TWMClientSynchronizationStrategy,
    };
  }
  return TwilioChatClient.Constants;
}

export default getConstants();
