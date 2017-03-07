import {
  NativeModules,
  Platform,
} from 'react-native';

const {
  TwilioChatClient,
} = NativeModules;

function getConstants() {
  if (Platform.OS === 'android') {
    return {
      TCHChannelStatus: TwilioChatClient.TCHChannelStatus,
      TCHChannelSynchronizationStatus: TwilioChatClient.TCHChannelSynchronizationStatus,
      TCHChannelType: TwilioChatClient.TCHChannelType,
      TCHChannelOption: TwilioChatClient.TCHChannelOption,
      TCHClientSynchronizationStatus: TwilioChatClient.TCHClientSynchronizationStatus,
      TCHClientSynchronizationStrategy: TwilioChatClient.TCHClientSynchronizationStrategy,
      TCHLogLevel: TwilioChatClient.TCHLogLevel,
    };
  }
  return TwilioChatClient.Constants;
}

export default getConstants();
