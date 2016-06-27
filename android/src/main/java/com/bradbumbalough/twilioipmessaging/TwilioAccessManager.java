package com.bradbumbalough.TwilioIPMessaging;

import com.twilio.common.TwilioAccessManagerFactory;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class TwilioAccessManager implements ReactContextBaseJavaModule {
    
    private TwilioAccessManager accessManager;
    
    @Override
    public String getName() {
        return "TwilioAccessManager";
    }

    @ReactMethod
    public void accessManagerWithToken(String token) {
        accessManager = TwilioAccessManagerFactory.TwilioAccessManager(token, this);
    }
}