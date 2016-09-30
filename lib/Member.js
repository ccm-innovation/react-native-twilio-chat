let UserInfo = require('./UserInfo')


class Member {
    constructor(props) {
        this.userInfo = new UserInfo(props.userInfo)
        this.lastConsumedMessageIndex = props.lastConsumedMessageIndex
        this.lastConsumptionTimestamp = this.lastConsumptionTimestamp ? new Date(this.lastConsumptionTimestamp) : null
    }
}

module.exports = Member