package com.bradbumbalough.RCTTwilioIPMessaging;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableType;
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
import org.json.JSONArray;

import java.sql.Wrapper;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.Calendar;

public class RCTConvert {

    private static WritableMap mapToWritableMap(Map<String,String> map) {
        if (map == null) {
            return null;
        }
        WritableMap writableMap = Arguments.createMap();
        for (String key : map.keySet()) {
            writableMap.putString(key, map.get(key));
        }
        return writableMap;
    }

    public static HashMap<String, Object> readableMapToHashMap(ReadableMap readableMap) {
        if (readableMap == null) {
            return null;
        }
        HashMap map = new HashMap<String, Object>();
        ReadableMapKeySetIterator keySetIterator = readableMap.keySetIterator();
        while (keySetIterator.hasNextKey()) {
            String key = keySetIterator.nextKey();
            map.put(key, readableMap.getString(key));
        }
        return map;
    }

    public static JSONObject readableMapToJson(ReadableMap readableMap) {
        JSONObject jsonObject = new JSONObject();

        if (readableMap == null) {
            return null;
        }

        ReadableMapKeySetIterator iterator = readableMap.keySetIterator();
        if (!iterator.hasNextKey()) {
            return null;
        }

        while (iterator.hasNextKey()) {
            String key = iterator.nextKey();
            ReadableType readableType = readableMap.getType(key);

            try {
                switch (readableType) {
                    case Null:
                        jsonObject.put(key, null);
                        break;
                    case Boolean:
                        jsonObject.put(key, readableMap.getBoolean(key));
                        break;
                    case Number:
                        // Can be int or double.
                        jsonObject.put(key, readableMap.getInt(key));
                        break;
                    case String:
                        jsonObject.put(key, readableMap.getString(key));
                        break;
                    case Map:
                        jsonObject.put(key, readableMapToJson(readableMap.getMap(key)));
                        break;
                    case Array:
                        jsonObject.put(key, readableMap.getArray(key));
                    default:
                        // Do nothing and fail silently
                }
            } catch (JSONException ex) {
                // Do nothing and fail silently
            }
        }

        return jsonObject;
    }

    public static WritableMap jsonToWritableMap(JSONObject jsonObject) {
        WritableMap writableMap = new WritableNativeMap();

        if (jsonObject == null) {
            return null;
        }


        Iterator<String> iterator = jsonObject.keys();
        if (!iterator.hasNext()) {
            return null;
        }

        while (iterator.hasNext()) {
            String key = iterator.next();

            try {
                Object value = jsonObject.get(key);

                if (value == null) {
                    writableMap.putNull(key);
                } else if (value instanceof Boolean) {
                    writableMap.putBoolean(key, (Boolean) value);
                } else if (value instanceof Integer) {
                    writableMap.putInt(key, (Integer) value);
                } else if (value instanceof Double) {
                    writableMap.putDouble(key, (Double) value);
                } else if (value instanceof String) {
                    writableMap.putString(key, (String) value);
                } else if (value instanceof JSONObject) {
                    writableMap.putMap(key, jsonToWritableMap((JSONObject) value));
                } else if (value instanceof JSONArray) {
                    writableMap.putArray(key, jsonArrayToWritableArray((JSONArray) value));
                }
            } catch (JSONException ex) {
                // Do nothing and fail silently
            }
        }

        return writableMap;
    }

    public static WritableArray jsonArrayToWritableArray(JSONArray jsonArray) {
        WritableArray writableArray = new WritableNativeArray();

        if (jsonArray == null) {
            return null;
        }

        if (jsonArray.length() <= 0) {
            return null;
        }

        for (int i = 0 ; i < jsonArray.length(); i++) {
            try {
                Object value = jsonArray.get(i);
                if (value == null) {
                    writableArray.pushNull();
                } else if (value instanceof Boolean) {
                    writableArray.pushBoolean((Boolean) value);
                } else if (value instanceof Integer) {
                    writableArray.pushInt((Integer) value);
                } else if (value instanceof Double) {
                    writableArray.pushDouble((Double) value);
                } else if (value instanceof String) {
                    writableArray.pushString((String) value);
                } else if (value instanceof JSONObject) {
                    writableArray.pushMap(jsonToWritableMap((JSONObject) value));
                } else if (value instanceof JSONArray) {
                    writableArray.pushArray(jsonArrayToWritableArray((JSONArray) value));
                }
            } catch (JSONException e) {
                // Do nothing and fail silently
            }
        }

        return writableArray;
    }

    public static WritableMap Channel(Channel channel) {
        WritableMap map = Arguments.createMap();

        map.putString("sid", channel.getSid());
        map.putString("friendlyName", channel.getFriendlyName());
        map.putString("uniqueName", channel.getUniqueName());
        map.putString("status", channel.getStatus().toString());
        map.putString("type", channel.getType().toString());
        map.putMap("attributes", jsonToWritableMap(channel.getAttributes()));
        map.putString("synchronizationStatus", channel.getSynchronizationStatus().toString());
        map.putString("dateCreated", channel.getDateCreated().toString());
        map.putString("dateUpdated", channel.getDateUpdated().toString());
        return map;
    }

    public static WritableMap UserInfo(UserInfo userInfo) {
        WritableMap map = Arguments.createMap();

        map.putString("identity", userInfo.getIdentity());
        map.putString("friendlyName", userInfo.getFriendlyName());
        map.putMap("attributes", jsonToWritableMap(userInfo.getAttributes()));
        map.putBoolean("isOnline", userInfo.isOnline());
        map.putBoolean("isNotifiable", userInfo.isNotifiable());

        return map;
    }

    public static WritableMap Message(Message message) {
        WritableMap map = Arguments.createMap();

        map.putString("sid", message.getSid());
        map.putString("index", String.valueOf(message.getMessageIndex()));
        map.putString("author", message.getAuthor());
        map.putString("body", message.getMessageBody());
        map.putString("timestamp", message.getTimeStamp());
        map.putMap("attributes", jsonToWritableMap(message.getAttributes()));
        return map;
    }

    public static WritableMap Member(Member member) {
        WritableMap map = Arguments.createMap();

        map.putMap("userInfo", UserInfo(member.getUserInfo()));
        map.putInt("lastConsumedMessageIndex", member.getLastConsumedMessageIndex().intValue());
        map.putString("lastConsumedMessageTimestamp", member.getLastConsumptionTimestamp());

        return map;
    }

    public static WritableMap TwilioIPMessagingClient(TwilioIPMessagingClient client) {
        WritableMap map = Arguments.createMap();

        map.putMap("userInfo", UserInfo(client.getMyUserInfo()));
        map.putBoolean("isReachabilityEnabled", client.isReachabilityEnabled());

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
