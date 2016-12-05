import React, {
    NativeModules,
} from 'react-native';

const { TwilioChatPaginator } = NativeModules;

class Paginator {
  constructor(sid, paginator) {
    this.sid = sid;
    this.hasNextPage = paginator.hasNextPage;
    this.items = paginator.items;
  }
}

class MemberPaginator extends Paginator {
  nextPage() {
    if (this.hasNextPage) {
      return TwilioChatPaginator.requestNextPageMembers(this.sid)
      .then(({ sid, paginator }) => new MemberPaginator(sid, paginator));
    }
  }
}

class ChannelPaginator extends Paginator {
  nextPage() {
    if (this.hasNextPage) {
      return TwilioChatPaginator.requestNextPageChannels(this.sid)
      .then(({ sid, paginator }) => new ChannelPaginator(sid, paginator));
    }
  }
}

exports.MemberPaginator = MemberPaginator;
exports.ChannelPaginator = ChannelPaginator;
