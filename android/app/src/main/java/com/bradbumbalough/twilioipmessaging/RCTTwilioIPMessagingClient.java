package com.bradbumbalough.twilioipmessaging;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableMap;

import com.twilio.common.TwilioAccessManager;
import com.twilio.ipmessaging.Channel;
import com.twilio.ipmessaging.Constants;
import com.twilio.ipmessaging.ErrorInfo;
import com.twilio.ipmessaging.TwilioIPMessagingClient;
import com.twilio.ipmessaging.TwilioIPMessagingSDK;

import java.util.HashMap;
import java.util.Map;


public class RCTTwilioIPMessagingClient extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioIPMessagingClient";
    }

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

        return constants;
    }


    public TwilioIPMessagingClient client = null;
    private ReactApplicationContext reactContext;

    private static RCTTwilioIPMessagingClient rctTwilioIPMessagingClient = new RCTTwilioIPMessagingClient(null);

    public static RCTTwilioIPMessagingClient getInstance() {
        return rctTwilioIPMessagingClient;
    }

    public RCTTwilioIPMessagingClient(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @ReactMethod
    public void createClient(ReadableMap props) {
        final RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();
        TwilioAccessManager accessManager = RCTTwilioAccessManager.getInstance().accessManager;

        TwilioIPMessagingClient.Properties.Builder builder = new TwilioIPMessagingClient.Properties.Builder();
        builder.setInitialMessageCount(props.getInt("initialMessageCount"));
        builder.setSynchronizationStrategy(TwilioIPMessagingClient.SynchronizationStrategy.ALL);

        Constants.CallbackListener<TwilioIPMessagingClient> listener = new Constants.CallbackListener<TwilioIPMessagingClient>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
            }

            @Override
            public void onSuccess(TwilioIPMessagingClient twilioIPMessagingClient) {
                tmp.client = twilioIPMessagingClient;
            }
        };

        TwilioIPMessagingSDK.createClient(accessManager, builder.createProperties(), listener);
    }

    @ReactMethod
    public void userInfo(Promise promise) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();
        promise.resolve(tmp.client.getMyUserInfo());
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
    public void handleNotification(Map<String,String> notification) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();
        tmp.client.handleNotification(notification);
    }

    @ReactMethod
    public void shutdown() {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();
        tmp.client.shutdown();
    }

    @ReactMethod
    public void setFriendlyName(String friendlyName, final Promise promise) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();

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

        tmp.client.getMyUserInfo().setFriendlyName(friendlyName, listener);
    }

    @ReactMethod
    public void setAttributes(Map<String,String> attributes, final Promise promise) {
        RCTTwilioIPMessagingClient tmp = RCTTwilioIPMessagingClient.getInstance();

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

        tmp.client.getMyUserInfo().setAttributes(attributes, listener);
    }

    // TODO Constants

    // TODO Listeners
}
