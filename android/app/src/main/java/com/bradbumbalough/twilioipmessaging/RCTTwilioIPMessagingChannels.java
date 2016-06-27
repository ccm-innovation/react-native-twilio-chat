package com.bradbumbalough.twilioipmessaging;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import com.twilio.ipmessaging.Channel;
import com.twilio.ipmessaging.Constants;
import com.twilio.ipmessaging.ErrorInfo;
import com.twilio.ipmessaging.Channels;


import java.util.Map;


public class RCTTwilioIPMessagingChannels extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioIPMessagingChannels";
    }

    private Channels channels = RCTTwilioIPMessagingClient.getInstance().client.getChannels();
    private ReactApplicationContext reactContext;


    public RCTTwilioIPMessagingChannels(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    private Channel loadChannelFromSid(String sid) {
        Channel channel = channels.getChannel(sid);
        return channel;
    }

    @ReactMethod
    public void getChannels(final Promise promise) {

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess() {
                promise.resolve(channels.getChannels());
            }
        };
        channels.loadChannelsWithListener(listener);
    }

    @ReactMethod
    public void createChannel(Map<String,Object> options, final Promise promise) {

        Constants.CreateChannelListener listener = new Constants.CreateChannelListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onCreated(Channel newChannel) {
                promise.resolve(newChannel);
            }
        };
       channels.createChannel(options, listener);
    }

    @ReactMethod
    public void getChannel(String sid, Promise promise) {
        promise.resolve(channels.getChannel(sid));
    }

    @ReactMethod
    public void getChannelByUniqueName(String uniqueName, Promise promise) {
        promise.resolve(channels.getChannelByUniqueName(uniqueName));
    }

    // Channel Instance Methods

    @ReactMethod
    public void synchronize(String sid, final Promise promise) {

        Constants.CallbackListener<Channel> listener = new Constants.CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess(Channel channel) {
                promise.resolve(true);
            }
        };

        loadChannelFromSid(sid).synchronize(listener);
    }

    @ReactMethod
    public void setAttributes(String sid, Map<String,String> attributes, final Promise promise) {

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };

        loadChannelFromSid(sid).setAttributes(attributes, listener);
    }

    @ReactMethod
    public void setFriendlyName(String sid, String friendlyName, final Promise promise) {

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };

        loadChannelFromSid(sid).setFriendlyName(friendlyName, listener);
    }

    @ReactMethod
    public void setUniqueName(String sid, String uniqueName, final Promise promise) {

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };

        loadChannelFromSid(sid).setUniqueName(uniqueName, listener);
    }

    @ReactMethod
    public void join(String sid, final Promise promise) {

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };

        loadChannelFromSid(sid).join(listener);
    }

    @ReactMethod
    public void declineInvitation(String sid, final Promise promise) {

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };

        loadChannelFromSid(sid).declineInvitation(listener);
    }

    @ReactMethod
    public void leave(String sid, final Promise promise) {

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };

        loadChannelFromSid(sid).leave(listener);
    }

    @ReactMethod
    public void destroy(String sid, final Promise promise) {

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };

        loadChannelFromSid(sid).destroy(listener);
    }

    @ReactMethod
    public void typing(String sid) {
        loadChannelFromSid(sid).typing();
    }

}
