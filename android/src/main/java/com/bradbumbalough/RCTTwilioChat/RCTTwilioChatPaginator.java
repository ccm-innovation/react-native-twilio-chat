package com.bradbumbalough.RCTTwilioChat;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import com.twilio.chat.Paginator;
import com.twilio.chat.Channel;
import com.twilio.chat.ChannelDescriptor;
import com.twilio.chat.Member;

public class RCTTwilioChatPaginator extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioChatPaginator";
    }

    public Map<String, Object> paginators = null;

    private static RCTTwilioChatPaginator rctTwilioChatPaginator;

    public static RCTTwilioChatPaginator getInstance() {
        return rctTwilioChatClient;
    }

    public RCTTwilioChatPaginator(ReactApplicationContext reactContext) {
        super(reactContext);
        rctTwilioChatPaginator = this;
    }

    public static setPaginator(Object paginator) {
        RCTTwilioChatPaginator _paginator = RCTTwilioChatPaginator.getInstance();
        String uuid = UUID.randomUUID();
        _paginator.paginators.put(uuid, paginator);
        return uuid;
    }

    @ReactMethod
    public void requestNextPageChannelDescriptors(String sid, final Promise promise) {
        final RCTTwilioChatPaginator tmp = RCTTwilioChatPaginator.getInstance();
        Paginator _paginator = tmp.paginators.get(sid);

        Constants.CallbackListener<Paginator<ChannelDescriptor>> listener = new Constants.CallbackListener<Paginator<ChannelDescriptor>>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("request-next-page", "Error occurred while attempting to request the next page. Error Message: " + errorInfo.getErrorText());
            }

            @Override
            public void onSuccess(Paginator<ChannelDescriptor> paginator) {
                String uuid = RCTTwilioChatPaginator.setPaginator(paginator);
                promise.resolve(RCTConvert.Paginator(paginator, uuid, "ChannelDescriptor"));
            }
        };
        _paginator.requestNextPage(listener);
    }

    public void requestNextPageChannels(String sid, final Promise promise) {
        final RCTTwilioChatPaginator tmp = RCTTwilioChatPaginator.getInstance();
        Paginator _paginator = tmp.paginators.get(sid);

        Constants.CallbackListener<Paginator<Channel>> listener = new Constants.CallbackListener<Paginator<Channel>>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("request-next-page", "Error occurred while attempting to request the next page. Error Message: " + errorInfo.getErrorText());
            }

            @Override
            public void onSuccess(Paginator<Channel> paginator) {
                String uuid = RCTTwilioChatPaginator.setPaginator(paginator);
                promise.resolve(RCTConvert.Paginator(paginator, uuid, "Channel"));
            }
        };
        _paginator.requestNextPage(listener);
    }

    public void requestNextPageMembers(String sid, final Promise promise) {
        final RCTTwilioChatPaginator tmp = RCTTwilioChatPaginator.getInstance();
        Paginator _paginator = tmp.paginators.get(sid);

        Constants.CallbackListener<Paginator<Channel>> listener = new Constants.CallbackListener<Paginator<Member>>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("request-next-page", "Error occurred while attempting to request the next page. Error Message: " + errorInfo.getErrorText());
            }

            @Override
            public void onSuccess(Paginator<Member> paginator) {
                String uuid = RCTTwilioChatPaginator.setPaginator(paginator);
                promise.resolve(RCTConvert.Paginator(paginator, uuid, "Member"));
            }
        };
        _paginator.requestNextPage(listener);
    }

}
