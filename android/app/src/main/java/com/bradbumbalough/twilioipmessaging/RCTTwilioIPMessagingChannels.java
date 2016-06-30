package com.bradbumbalough.twilioipmessaging;

import android.support.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.twilio.ipmessaging.Channel;
import com.twilio.ipmessaging.ChannelListener;
import com.twilio.ipmessaging.Constants;
import com.twilio.ipmessaging.ErrorInfo;
import com.twilio.ipmessaging.Channels;
import com.twilio.ipmessaging.Member;
import com.twilio.ipmessaging.Message;

import java.util.HashMap;
import java.util.Map;


public class RCTTwilioIPMessagingChannels extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioIPMessagingChannels";
    }

    private ReactApplicationContext reactContext;
    private HashMap<String,ChannelListener> channelListeners = new HashMap<String, ChannelListener>();

    public RCTTwilioIPMessagingChannels(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        this.reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    private ChannelListener generateListener(final Channel channel) {
        final String channelSid = channel.getSid();

        ChannelListener listener = new ChannelListener() {
            @Override
            public void onMessageAdd(Message message) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("message", RCTConvert.Message(message));

                sendEvent("ipMessagingClient:channel:messageAdded", map);
            }

            @Override
            public void onMessageChange(Message message) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("message", RCTConvert.Message(message));

                sendEvent("ipMessagingClient:channel:messageChanged", map);
            }

            @Override
            public void onMessageDelete(Message message) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("message", RCTConvert.Message(message));

                sendEvent("ipMessagingClient:channel:messageDeleted", map);
            }

            @Override
            public void onMemberJoin(Member member) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("member", RCTConvert.Member(member));

                sendEvent("ipMessagingClient:channel:memberJoined", map);
            }

            @Override
            public void onMemberChange(Member member) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("member", RCTConvert.Member(member));

                sendEvent("ipMessagingClient:channel:memberChanged", map);
            }

            @Override
            public void onMemberDelete(Member member) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("member", RCTConvert.Member(member));

                sendEvent("ipMessagingClient:channel:memberLeft", map);
            }

            // TODO
            @Override
            public void onAttributesChange(Map<String, String> map) {

            }

            @Override
            public void onTypingStarted(Member member) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("member", RCTConvert.Member(member));

                sendEvent("ipMessagingClient:typingStartedOnChannel", map);
            }

            @Override
            public void onTypingEnded(Member member) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("member", RCTConvert.Member(member));

                sendEvent("ipMessagingClient:typingEndedOnChannel", map);
            }

            @Override
            public void onSynchronizationChange(Channel channel) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putString("status", channel.getSynchronizationStatus().toString());

                sendEvent("ipMessagingClient:channel:synchronizationStatusChanged", map);
            }
        };

        return listener;
    }

    private Channels channels() {
        return RCTTwilioIPMessagingClient.getInstance().client.getChannels();
    }

    private Channel loadChannelFromSid(String sid) {
        Channel channel = channels().getChannel(sid);
        if (channel.getListener() == null) {
            ChannelListener listener = generateListener(channel);
            channel.setListener(listener);
            channelListeners.put(channel.getSid(),listener);
        }
        return channel;
    }

    @ReactMethod
    public void getChannels(final Promise promise) {

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-channels-error", "Error occurred while attempting to getChannels.");
            }

            @Override
            public void onSuccess() {
                promise.resolve(channels().getChannels());
            }
        };
        channels().loadChannelsWithListener(listener);
    }

    @ReactMethod
    public void createChannel(Map<String,Object> options, final Promise promise) {

        Constants.CreateChannelListener listener = new Constants.CreateChannelListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("create-channel-error", "Error occurred while attempting to createChannel.");
            }

            @Override
            public void onCreated(Channel newChannel) {
                promise.resolve(newChannel);
            }
        };
       channels().createChannel(options, listener);
    }

    @ReactMethod
    public void getChannel(String sid, Promise promise) {
        promise.resolve(channels().getChannel(sid));
    }

    @ReactMethod
    public void getChannelByUniqueName(String uniqueName, Promise promise) {
        promise.resolve(channels().getChannelByUniqueName(uniqueName));
    }

    // Channel Instance Methods

    @ReactMethod
    public void synchronize(String sid, final Promise promise) {

        Constants.CallbackListener<Channel> listener = new Constants.CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("synchronize-error", "Error occurred while attempting to synchronize channel.");
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
                promise.reject("set-attributes-error", "Error occurred while attempting to setAttributes on channel.");
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
                promise.reject("set-friendly-name-error", "Error occurred while attempting to setFriendlyName on channel.");
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
                promise.reject("set-unique-name-error", "Error occurred while attempting to setUniqueName on channel.");
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
                promise.reject("join-error", "Error occurred while attempting to join channel.");
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
                promise.reject("decline-error", "Error occurred while attempting to decline channel.");
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
                promise.reject("leave-error", "Error occurred while attempting to leave channel.");
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
                promise.reject("delete-error", "Error occurred while attempting to delete channel.");
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
