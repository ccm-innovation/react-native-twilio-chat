package com.bradbumbalough.twilioipmessaging;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.twilio.ipmessaging.Channel;
import com.twilio.ipmessaging.UserInfo;

import org.json.JSONException;
import org.json.JSONObject;
import java.util.Iterator;
import java.util.Map;

public class RCTConvert {

    private static WritableMap convertMapToWritableMap(Map<String,String> map) {
        WritableMap writableMap = Arguments.createMap();
        for (String key : map.keySet()) {
            writableMap.putString(key, map.get(key));
        }
        return writableMap;
    }

    public static WritableMap Channel(Channel channel) {
        WritableMap map = Arguments.createMap();

        map.putString("sid", channel.getSid());
        map.putString("friendlyName", channel.getFriendlyName());
        map.putString("uniqueName", channel.getUniqueName());
        map.putString("status", channel.getStatus().toString());
        map.putString("type", channel.getType().toString());
        map.putMap("attributes", convertMapToWritableMap(channel.getAttributes()));
        map.putString("synchronizationStatus", channel.getSynchronizationStatus().toString());

        return map;
    }

    public static WritableMap UserInfo(UserInfo userInfo) {
        WritableMap map = Arguments.createMap();

        map.putString("identity", userInfo.getIdentity());
        map.putString("friendlyName", userInfo.getFriendlyName());
        map.putMap("attributes", convertMapToWritableMap(userInfo.getAttributes()));

        return map;
    }
}

