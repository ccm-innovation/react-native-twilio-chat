package com.bradbumbalough.RCTTwilioIPMessaging;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.twilio.common.TwilioAccessManager;
import com.twilio.common.TwilioAccessManagerFactory;
import com.twilio.common.TwilioAccessManagerListener;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class RCTTwilioAccessManager extends ReactContextBaseJavaModule implements TwilioAccessManagerListener {

    @Override
    public String getName() {
        return "TwilioAccessManager";
    }

    public TwilioAccessManager accessManager = null;
    private ReactApplicationContext reactContext;

    public static RCTTwilioAccessManager rctTwilioAccessManager;

    public static RCTTwilioAccessManager getInstance() {
        return rctTwilioAccessManager;
    }

    public RCTTwilioAccessManager(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        rctTwilioAccessManager = this;
    }

    @ReactMethod
    public void accessManagerWithToken(String token, Promise promise) {
        RCTTwilioAccessManager tmp = RCTTwilioAccessManager.getInstance();
        tmp.accessManager = TwilioAccessManagerFactory.createAccessManager(token, this);
        promise.resolve(RCTConvert.TwilioAccessManager(tmp.accessManager));
    }

    @Override
    public void onTokenExpired(TwilioAccessManager twilioAccessManager) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("accessManager:tokenExpired", null);
    }

    @Override
    public void onTokenUpdated(TwilioAccessManager twilioAccessManager) {

    }

    @Override
    public void onError(TwilioAccessManager twilioAccessManager, String s) {
        WritableMap params = Arguments.createMap();
        params.putString("error",s);
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("accessManager:tokenExpired",params);
    }

}
