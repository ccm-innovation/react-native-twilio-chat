let React = require('react-native')

let {
    NativeModules,
    Platform
} = React

let {
    TwilioChatClient,
} = NativeModules

function getConstants() {
  if (Platform.OS == 'android') {
    return {
      TWMChannelStatus: TwilioChatClient.TWMChannelStatus,
      TWMChannelSynchronizationStatus: TwilioChatClient.TWMChannelSynchronizationStatus,
      TWMChannelType: TwilioChatClient.TWMChannelType,
      TWMChannelOption: TwilioChatClient.TWMChannelOption,
      TWMClientSynchronizationStatus: TwilioChatClient.TWMClientSynchronizationStatus,
      TWMClientSynchronizationStrategy: TwilioChatClient.TWMClientSynchronizationStrategy,
    }
  }
  return TwilioChatClient.Constants
}

module.exports = getConstants()
