import {
    NativeModules,
} from 'react-native';

import ChannelDescriptor from './ChannelDescriptor';
import Member from './Member';
import UserDescriptor from './UserDescriptor';

const { TwilioChatPaginator } = NativeModules;

export default class Paginator {
  constructor(sid, type, paginator) {
    this.sid = sid;
    this.type = type;
    this.hasNextPage = paginator.hasNextPage;

    let items = [];
    if (type === 'ChannelDescriptor') {
      items = paginator.items.map(item => new ChannelDescriptor(item));
    } else if (type === 'UserDescriptor') {
      items = paginator.items.map(item => new UserDescriptor(item));
    } else {
      items = paginator.items.map(item => new Member(item, sid));
    }
    this.items = items;
  }

  nextPage() {
    if (this.hasNextPage) {
      if (this.type === 'ChannelDescriptor') {
        return TwilioChatPaginator.requestNextPageChannelDescriptors(this.sid)
        .then(this._returnNewPaginator);
      }
      else if (this.type === 'UserDescriptor') {
        return TwilioChatPaginator.requestNextPageUserDescriptors(this.sid)
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
