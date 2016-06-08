let React = require('react-native')

let {
    NativeModules,
} = React

let {
    TwilioIPMessagingMessages
} = NativeModules

class Message {
    
    constructor(props, channelSid) {
        this.sid = props.sid
        this.index = props.index
        this.author = props.author
        this.body = props.body
        this.timestamp = new Date(props.timestampAsDate)
        this.dateUpdated = props.dateUpdatedAsDate ? new Date(props.dateUpdatedAsDate) : null
        this.lastUpdatedBy = props.lastUpdatedBy
        this._channelSid = channelSid
    }
    
    updateBody(body) {
        return TwilioIPMessagingMessages.updateBody(this._channelSid, this.index, body)
    }
}

module.exports = Message