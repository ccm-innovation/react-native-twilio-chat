package com.bradbumbalough.RCTTwilioChat;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import com.twilio.chat.Paginator;
import com.twilio.chat.Channel;
import com.twilio.chat.ChannelDescriptor;
import com.twilio.chat.StatusListener;
import com.twilio.chat.Member;
import com.twilio.chat.CallbackListener;
import com.twilio.chat.ErrorInfo;
import com.twilio.chat.UserDescriptor;


import java.util.UUID;
import java.util.HashMap;

public class RCTTwilioChatPaginator extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioChatPaginator";
    }

    public static HashMap<String, Object> paginators = new HashMap<String, Object>();
//    public static Map<String, Paginator<ChannelDescriptor>> channelDescriptorPaginators = new Map<String, Paginator<ChannelDescriptor>>();
//    public static Map<String, Paginator<Member>> memberPaginators = new Map<String, Paginator<Member>>();

    private static RCTTwilioChatPaginator rctTwilioChatPaginator;

    public static RCTTwilioChatPaginator getInstance() {
        return rctTwilioChatPaginator;
    }

    public RCTTwilioChatPaginator(ReactApplicationContext reactContext) {
        super(reactContext);
        rctTwilioChatPaginator = this;
    }

    public static String setPaginator(Object paginator) {
        RCTTwilioChatPaginator _paginator = RCTTwilioChatPaginator.getInstance();
        String uuid = UUID.randomUUID().toString();
        _paginator.paginators.put(uuid, paginator);
        return uuid;
    }

    @ReactMethod
    public void requestNextPageChannelDescriptors(String sid, final Promise promise) {
        final RCTTwilioChatPaginator tmp = RCTTwilioChatPaginator.getInstance();
        Paginator<ChannelDescriptor> _paginator = (Paginator<ChannelDescriptor>)tmp.paginators.get(sid);

        _paginator.requestNextPage(new CallbackListener<Paginator<ChannelDescriptor>>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("request-next-page", "Error occurred while attempting to request the next page. Error Message: " + errorInfo.getMessage());
            }

            @Override
            public void onSuccess(Paginator<ChannelDescriptor> paginator) {
                String uuid = RCTTwilioChatPaginator.setPaginator(paginator);
                promise.resolve(RCTConvert.Paginator(paginator, uuid, "ChannelDescriptor"));
            }
        });
    }

    public void requestNextPageUserDescriptors(String sid, final Promise promise) {
        final RCTTwilioChatPaginator tmp = RCTTwilioChatPaginator.getInstance();
        Paginator<UserDescriptor> _paginator = (Paginator<UserDescriptor>)tmp.paginators.get(sid);

        _paginator.requestNextPage(new CallbackListener<Paginator<UserDescriptor>>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("request-next-page", "Error occurred while attempting to request the next page. Error Message: " + errorInfo.getMessage());
            }

            @Override
            public void onSuccess(Paginator<UserDescriptor> paginator) {
                String uuid = RCTTwilioChatPaginator.setPaginator(paginator);
                promise.resolve(RCTConvert.Paginator(paginator, uuid, "UserDescriptor"));
            }
        });
    }

    public void requestNextPageMembers(String sid, final Promise promise) {
        final RCTTwilioChatPaginator tmp = RCTTwilioChatPaginator.getInstance();
        Paginator<Member> _paginator = (Paginator<Member>)tmp.paginators.get(sid);

        _paginator.requestNextPage(new CallbackListener<Paginator<Member>>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("request-next-page", "Error occurred while attempting to request the next page. Error Message: " + errorInfo.getMessage());
            }

            @Override
            public void onSuccess(Paginator<Member> paginator) {
                String uuid = RCTTwilioChatPaginator.setPaginator(paginator);
                promise.resolve(RCTConvert.Paginator(paginator, uuid, "Member"));
            }
        });
    }

}
