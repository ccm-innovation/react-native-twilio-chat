
class Member {
  constructor(props) {
    this.identity = props.identity;
    this.lastConsumedMessageIndex = props.lastConsumedMessageIndex;
    this.lastConsumptionTimestamp = this.lastConsumptionTimestamp ? new Date(this.lastConsumptionTimestamp) : null;
  }
}

export default Member;
