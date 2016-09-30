package com.bradbumbalough.RCTTwilioIPMessaging;

import android.support.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.ReadableMap;

import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.twilio.common.TwilioAccessManager;
import com.twilio.ipmessaging.Channel;
import com.twilio.ipmessaging.Constants;
import com.twilio.ipmessaging.ErrorInfo;
import com.twilio.ipmessaging.IPMessagingClientListener;
import com.twilio.ipmessaging.TwilioIPMessagingClient;
import com.twilio.ipmessaging.TwilioIPMessagingSDK;
import com.twilio.ipmessaging.UserInfo;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;


public class RCTTwilioIPMessagingClient extends ReactContextBaseJavaModule implements IPMessagingClientListener {

    @Override
    public String getName() {
        return "TwilioIPMessagingClient";
    }

    // Constants

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();

        Map<String, String> channelStatus = new HashMap<>();
        channelStatus.put("Invited", Channel.ChannelStatus.INVITED.toString());
        channelStatus.put("Joined",Channel.ChannelStatus.JOINED.toString());
        channelStatus.put("NotParticipating",Channel.ChannelStatus.NOT_PARTICIPATING.toString());
        constants.put("TWMChannelStatus", channelStatus);

        Map<String, String> channelSyncStatus = new HashMap<>();
        channelSyncStatus.put("None",Channel.SynchronizationStatus.NONE.toString());
        channelSyncStatus.put("Identifier",Channel.SynchronizationStatus.IDENTIFIER.toString());
        channelSyncStatus.put("Metadata",Channel.SynchronizationStatus.METADATA.toString());
        channelSyncStatus.put("All",Channel.SynchronizationStatus.ALL.toString());
        channelSyncStatus.put("Failed",Channel.SynchronizationStatus.FAILED.toString());
        constants.put("TWMChannelSynchronizationStatus", channelSyncStatus);

        Map<String, String> channelType = new HashMap<>();
        channelType.put("Public",Channel.ChannelType.CHANNEL_TYPE_PUBLIC.toString());
        channelType.put("Private",Channel.ChannelType.CHANNEL_TYPE_PRIVATE.toString());
        constants.put("TWMChannelType", channelType);

        Map<String, String> clientSyncStatus = new HashMap<>();
        clientSyncStatus.put("Started",TwilioIPMessagingClient.SynchronizationStatus.STARTED.toString());
        clientSyncStatus.put("ChannelListCompleted",TwilioIPMessagingClient.SynchronizationStatus.CHANNELS_COMPLETED.toString());
        clientSyncStatus.put("Completed",TwilioIPMessagingClient.SynchronizationStatus.COMPLETED.toString());
        clientSyncStatus.put("Failed",TwilioIPMessagingClient.SynchronizationStatus.FAILED.toString());
        constants.put("TWMClientSynchronizationStatus", clientSyncStatus);

        Map<String, String> clientSyncStrategy = new HashMap<>();
        clientSyncStrategy.put("All",TwilioIPMessagingClient.SynchronizationStrategy.ALL.toString());
        clientSyncStrategy.put("ChannelsList",TwilioIPMessagingClient.SynchronizationStrategy.CHANNELS_LIST.toString());
        constants.put("TWMClientSynchronizationStrategy", clientSyncStrategy);

        Map<String, String> channelOption = new HashMap<>();
        channelOption.put("FriendlyName", "friendlyName");
        channelOption.put("UniqueName", "uniqueName");
        channelOption.put("Type", "type");
        channelOption.put("Attributes", "attributes");
        constants.put("TWMChannelOption", channelOption);
        
        return constants;
    }

    public TwilioIPMessagingClient client = null;
    private ReactApplicationContext reactContext;

    private static RCTTwilioIPMessagingClient rctTwilioIPMessagingClient;

    public static RCTTwilioIPMessagingClient getInstance() {
        return rctTwilioIPMessagingClient;
    }

    public RCTTwilioIPMessagingClient(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        rctTwilioIPMessagingClient = this;
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();
        tmp.reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    private void sendEvent(String eventName, @Nullable String body) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();
        tmp.reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, body);
    }

    private Constants.StatusListener generateStatusListener(final Promise promise, final String errorCode, final String errorMessage) {
        return new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject(errorCode, errorMessage + " Error Message: " + errorInfo.getErrorText());
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };
    }

    // Methods

    @ReactMethod
    public void createClient(ReadableMap props, final Promise promise) {
        final RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();
        TwilioAccessManager accessManager = RCTTwilioAccessManager.getInstance().accessManager;

        TwilioIPMessagingClient.Properties.Builder builder = new TwilioIPMessagingClient.Properties.Builder();

        if (props != null) {
            if (props.hasKey("initialMessageCount")) {
                builder.setInitialMessageCount(props.getInt("initialMessageCount"));
            }
            if (props.hasKey("synchronizationStrategy")) {
                builder.setSynchronizationStrategy(TwilioIPMessagingClient.SynchronizationStrategy.valueOf(props.getString("synchronizationStrategy")));
            }
        }

        Constants.CallbackListener<TwilioIPMessagingClient> listener = new Constants.CallbackListener<TwilioIPMessagingClient>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("create-client-error", "Error occurred while attempting to create the client. Error Message: " + errorInfo.getErrorText());
            }

            @Override
            public void onSuccess(TwilioIPMessagingClient twilioIPMessagingClient) {
                tmp.client = twilioIPMessagingClient;
                promise.resolve(RCTConvert.TwilioIPMessagingClient(tmp.client));
            }
        };
        tmp.client = TwilioIPMessagingSDK.createClient(accessManager, builder.createProperties(), listener);
        tmp.client.setListener(this);
    }

    @ReactMethod
    public void userInfo(Promise promise) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();
        promise.resolve(RCTConvert.UserInfo(tmp.client.getMyUserInfo()));
    }

    @ReactMethod
    public void register(String token) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess() {

            }
        };
        tmp.client.registerGCMToken(token, listener);
    }

    @ReactMethod
    public void unregister(String token) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess() {

            }
        };
        tmp.client.unregisterGCMToken(token, listener);
    }

    @ReactMethod
    public void handleNotification(ReadableMap notification) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();
        HashMap map = RCTConvert.readableMapToHashMap(notification);
        tmp.client.handleNotification(map);
    }

    @ReactMethod
    public void shutdown() {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();
        tmp.client.shutdown();
    }

    // UserInfo methods

    @ReactMethod
    public void setFriendlyName(String friendlyName, final Promise promise) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("set-friendly-name-error", "Error occurred while attempting to setFriendlyName on user.");
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };

        tmp.client.getMyUserInfo().setFriendlyName(friendlyName, listener);
    }

    @ReactMethod
    public void setAttributes(ReadableMap attributes, final Promise promise) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();
        JSONObject json = RCTConvert.readableMapToJson(attributes);

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("set-attributes-error", "Error occurred while attempting to setAttributes on user.");
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };

        tmp.client.getMyUserInfo().setAttributes(json, listener);
    }

    // Listeners

    @Override
    public void onChannelAdd(Channel channel) {
        sendEvent("ipMessagingClient:channelAdded", RCTConvert.Channel(channel));
    }

    @Override
    public void onChannelChange(Channel channel) {
        sendEvent("ipMessagingClient:channelChanged", RCTConvert.Channel(channel));
    }

    @Override
    public void onChannelDelete(Channel channel){
        sendEvent("ipMessagingClient:channelRemoved", RCTConvert.Channel(channel));
    }

    @Override
    public void onChannelSynchronizationChange(Channel channel) {
        WritableMap map = Arguments.createMap();
        map.putString("channelSid",channel.getSid());
        map.putString("status", channel.getSynchronizationStatus().toString());

        sendEvent("ipMessagingClient:channel:synchronizationStatusChanged", map);
    }

    @Override
    public void onClientSynchronization(TwilioIPMessagingClient.SynchronizationStatus synchronizationStatus) {
        sendEvent("ipMessagingClient:synchronizationStatusChanged", synchronizationStatus.toString());
    }

    @Override
    public void onError(ErrorInfo errorInfo) {
        WritableMap map = Arguments.createMap();
        map.putString("error",errorInfo.getErrorText());
        map.putString("userInfo", errorInfo.toString());

        sendEvent("ipMessagingClient:errorReceived", map);
    }

    @Override
    public void onUserInfoChange(UserInfo userInfo) {
        WritableMap map = Arguments.createMap();
        map.putMap("userInfo",RCTConvert.UserInfo(userInfo));
        map.putNull("updated");

        sendEvent("ipMessagingClient:userInfoUpdated", map);
    }

    @Override
    public void onToastFailed(ErrorInfo errorInfo) {
        WritableMap map = Arguments.createMap();
        map.putString("error",errorInfo.getErrorText());
        map.putString("userInfo", errorInfo.toString());

        sendEvent("ipMessagingClient:toastFailed", map);
    }

    @Override
    public void onToastSubscribed() {
        sendEvent("ipMessagingClient:toastSubscribed", "");
    }

    @Override
    public void onToastNotification(String channelSid, String messageSid) {
        WritableMap map = Arguments.createMap();
        map.putString("channelSid", channelSid);
        map.putString("messageSid", messageSid);

        sendEvent("ipMessagingClient:toastReceived", map);
    }
}
