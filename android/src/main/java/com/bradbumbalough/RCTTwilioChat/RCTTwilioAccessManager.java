package com.bradbumbalough.RCTTwilioChat;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import com.twilio.accessmanager.AccessManager;


public class RCTTwilioAccessManager extends ReactContextBaseJavaModule implements AccessManager.Listener {

    @Override
    public String getName() {
        return "TwilioAccessManager";
    }

    public AccessManager accessManager = null;
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
        tmp.accessManager = new AccessManager(token, this);
        promise.resolve(RCTConvert.AccessManager(tmp.accessManager));
    }

    @ReactMethod
    public void updateToken(String token, Promise promise) {
      RCTTwilioAccessManager tmp = RCTTwilioAccessManager.getInstance();
      tmp.accessManager.updateToken(token);
      promise.resolve(RCTConvert.AccessManager(tmp.accessManager));
    }

    @Override
    public void onTokenExpired(AccessManager twilioAccessManager) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("accessManager:tokenExpired", null);
    }

    @Override
    public void onTokenWillExpire(AccessManager twilioAccessManager) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("accessManager:tokenWillExpire", null);
    }

    @Override
    public void onError(AccessManager twilioAccessManager, String s) {
        WritableMap params = Arguments.createMap();
        params.putString("error",s);
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("accessManager:tokenInvalid",params);
    }

}
