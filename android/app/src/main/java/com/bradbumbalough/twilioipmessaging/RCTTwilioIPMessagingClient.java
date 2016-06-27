package com.bradbumbalough.twilioipmessaging;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.bridge.ReadableMap;

import com.twilio.common.TwilioAccessManager;
import com.twilio.ipmessaging.Channel;
import com.twilio.ipmessaging.Constants;
import com.twilio.ipmessaging.ErrorInfo;
import com.twilio.ipmessaging.IPMessagingClientListener;
import com.twilio.ipmessaging.TwilioIPMessagingClient;
import com.twilio.ipmessaging.TwilioIPMessagingSDK;
import com.twilio.ipmessaging.UserInfo;


import java.util.Map;


public class RCTTwilioIPMessagingClient extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioIPMessagingClient";
    }

    private TwilioIPMessagingClient client = null;
    private ReactApplicationContext reactContext;

    private static RCTTwilioIPMessagingClient rctTwilioIPMessagingClient = new RCTTwilioIPMessagingClient(null);

    private static RCTTwilioIPMessagingClient getInstance() {
        return rctTwilioIPMessagingClient;
    }

    public RCTTwilioIPMessagingClient(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @ReactMethod
    public void ipMessagingClientWithAccessManager(ReadableMap props) {
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
    public void registerWithToken(String token) {
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
    public void deregisterWithToken(String token) {
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
    public void setFriendlyName(String friendlyName, Promise promise) {
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

        tmp.client.getMyUserInfo().setFriendlyName(friendlyName, listener);
    }

    @ReactMethod
    public void setAttributed(Map<String,String> attributes, final Promise promise) {
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
}
