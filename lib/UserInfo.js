let React = require('react-native')

let {
    NativeModules
} = React

let {
    TwilioIPMessagingClient
} = NativeModules

class UserInfo {
    constructor(props) {
        this.identity = props.identity
        this.friendlyName = props.friendlyName
        this.attributes = props.attributes
    }
    
    setAttributes(attributes) {
        return TwilioIPMessagingClient.setAttributes(attributes)
    }
    
    setFriendlyName(friendlyName) {
        return TwilioIPMessagingClient.setFriendlyName(friendlyName)
    }
}

module.exports = UserInfo