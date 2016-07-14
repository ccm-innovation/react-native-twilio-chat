let UserInfo = require('./UserInfo')


class Member {
    constructor(props) {
        this.userInfo = new UserInfo(props.userInfo)
        this.lastConsumedMessageIndex = props.lastConsumedMessageIndex
        this.lastConsumedMessageTimestamp = this.lastConsumedMessageTimestamp ? new Date(this.lastConsumedMessageTimestamp) : null
    }
}

module.exports = Member