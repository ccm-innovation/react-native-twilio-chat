package com.bradbumbalough.RCTTwilioIPMessaging;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;

import com.twilio.common.TwilioAccessManager;
import com.twilio.ipmessaging.Channel;
import com.twilio.ipmessaging.Channels;
import com.twilio.ipmessaging.TwilioIPMessagingClient;
import com.twilio.ipmessaging.UserInfo;
import com.twilio.ipmessaging.Message;
import com.twilio.ipmessaging.Member;

import org.json.JSONException;
import org.json.JSONObject;

import java.sql.Wrapper;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.Calendar;


public class RCTConvert {

    private static WritableMap convertMapToWritableMap(Map<String,String> map) {
        WritableMap writableMap = Arguments.createMap();
        for (String key : map.keySet()) {
            writableMap.putString(key, map.get(key));
        }
        return writableMap;
    }

    public static HashMap<String, Object> convertReadableMapToHashMap(ReadableMap readableMap) {
        HashMap map = new HashMap<String, Object>();
        ReadableMapKeySetIterator keySetIterator = readableMap.keySetIterator();
        while (keySetIterator.hasNextKey()) {
            String key = keySetIterator.nextKey();
            map.put(key, readableMap.getString(key));
        }
        return map;
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

    public static WritableMap Message(Message message) {
        WritableMap map = Arguments.createMap();

        map.putString("sid", message.getSid());
        map.putString("index", String.valueOf(message.getMessageIndex()));
        map.putString("author", message.getAuthor());
        map.putString("body", message.getMessageBody());
        map.putString("timestamp", message.getTimeStamp());

        return map;
    }

    public static WritableMap Member(Member member) {
        WritableMap map = Arguments.createMap();

        map.putMap("userInfo", UserInfo(member.getUserInfo()));

        return map;
    }

    public static WritableMap TwilioIPMessagingClient(TwilioIPMessagingClient client) {
        WritableMap map = Arguments.createMap();

        map.putMap("userInfo", UserInfo(client.getMyUserInfo()));

        return map;
    }

    public static WritableMap TwilioAccessManager(TwilioAccessManager accessManager) {
        WritableMap map = Arguments.createMap();

        map.putString("identity", accessManager.getIdentity());
        map.putString("token", accessManager.getToken());
        map.putBoolean("isExpired", accessManager.isExpired());
        map.putString("expirationDate", accessManager.getExpirationDate().toString());

        return map;
    }

    public static WritableArray Channels(Channel[] channels) {
        WritableArray array = Arguments.createArray();

        for (Channel c : channels) {
            array.pushMap(Channel(c));
        }

        return array;
    }

    public static WritableArray Members(Member[] members) {
        WritableArray array = Arguments.createArray();

        for (Member m : members) {
            array.pushMap(Member(m));
        }

        return array;
    }

    public static WritableArray Messages(List<Message> messages) {
        WritableArray array = Arguments.createArray();

        for (Message m : messages) {
            array.pushMap(Message(m));
        }

        return array;
    }
}

