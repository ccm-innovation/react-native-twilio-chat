package com.bradbumbalough.RCTTwilioChat;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


public class RCTTwilioChatPackage implements ReactPackage {
    public List<Class<? extends JavaScriptModule>> createJSModules() {
        return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }

    @Override
    public List<NativeModule> createNativeModules(
            ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();

        modules.add(new RCTTwilioAccessManager(reactContext));
        modules.add(new RCTTwilioChatClient(reactContext));
        modules.add(new RCTTwilioChatChannels(reactContext));
        modules.add(new RCTTwilioChatMembers(reactContext));
        modules.add(new RCTTwilioChatMessages(reactContext));
        modules.add(new RCTTwilioChatPaginator(reactContext));

        return modules;
    }
}
