let React = require('react-native')

let {
    NativeModules,
    Platform
} = React

let {
    TwilioIPMessagingClient,
} = NativeModules

function getConstants() {
  if (Platform.OS == 'android') {
    return {
      TWMChannelStatus: TwilioIPMessagingClient.TWMChannelStatus,
      TWMChannelSynchronizationStatus: TwilioIPMessagingClient.TWMChannelSynchronizationStatus,
      TWMChannelType: TwilioIPMessagingClient.TWMChannelType,
      TWMClientSynchronizationStatus: TwilioIPMessagingClient.TWMClientSynchronizationStatus,
      TWMClientSynchronizationStrategy: TwilioIPMessagingClient.TWMClientSynchronizationStrategy,
    }
  }
  return TwilioIPMessagingClient.Constants
}

module.exports = getConstants()
