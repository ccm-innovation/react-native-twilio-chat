import {
    NativeModules,
} from 'react-native';

import Channel from './Channel';
import Member from './Member';

const { TwilioChatPaginator } = NativeModules;

export default class Paginator {
  constructor(sid, type, paginator) {
    this.sid = sid;
    this.type = type;
    this.hasNextPage = paginator.hasNextPage;

    let items = [];
    if (type === 'Channel' || type === 'ChannelDescriptor') {
      items = paginator.items.map(item => new Channel(item));
    } else {
      items = paginator.items.map(item => new Member(item));
    }
    this.items = items;
  }

  nextPage() {
    if (this.hasNextPage) {
      if (this.type === 'Channel') {
        return TwilioChatPaginator.requestNextPageChannels(this.sid)
        .then(this._returnNewPaginator);
      }
      else if (this.type === 'ChannelDescriptor') {
        return TwilioChatPaginator.requestNextPageChannelDescriptors(this.sid)
        .then(this._returnNewPaginator);
      }
      else {
        return TwilioChatPaginator.requestNextPageMembers(this.sid)
        .then(this._returnNewPaginator);
      }
    }
  }

  _returnNewPaginator({ sid, type, paginator }) {
    return new Paginator(sid, type, paginator);
  }
}
