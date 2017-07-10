package com.bradbumbalough.RCTTwilioChat;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.ReadableMapKeySetIterator;

import com.twilio.chat.Channel;
import com.twilio.chat.ChannelDescriptor;
import com.twilio.chat.Channels;
import com.twilio.chat.ChatClient;
import com.twilio.chat.User;
import com.twilio.chat.UserDescriptor;
import com.twilio.chat.Message;
import com.twilio.chat.Member;
import com.twilio.chat.Paginator;
import com.twilio.accessmanager.AccessManager;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;

import java.sql.Array;
import java.sql.Wrapper;
import java.util.Iterator;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
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
            ReadableType type = readableMap.getType(key);
            switch(type) {
                case String:
                    map.put(key, readableMap.getString(key));
                    break;
                case Map:
                    HashMap<String, Object> attributes = new RCTConvert().readableMapToHashMap(readableMap.getMap(key));
                    map.put(key, attributes);
                    break;
                default:
                    // do nothing
            }
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


        try {
            while (iterator.hasNext()) {
                String key = iterator.next();
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
            }
        } catch (JSONException ex){
                // Do nothing and fail silently
        }

        return writableMap;
    }

    public static WritableArray jsonArrayToWritableArray(JSONArray jsonArray) {
        WritableArray writableArray = new WritableNativeArray();

        try {
            if (jsonArray == null) {
                return null;
            }

            if (jsonArray.length() <= 0) {
                return null;
            }

            for (int i = 0 ; i < jsonArray.length(); i++) {
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
            }
        } catch (JSONException e) {
            // Do nothing and fail silently
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
        map.putString("synchronizationStatus", channel.getSynchronizationStatus().toString());
        map.putString("dateCreated", channel.getDateCreated().toString());
        map.putString("dateUpdated", channel.getDateUpdated().toString());
        WritableMap attributes = Arguments.createMap();
        try {
            attributes = jsonToWritableMap(channel.getAttributes());
        }
        catch (JSONException e) {}
        map.putMap("attributes", attributes);
        return map;
    }

    public static WritableMap ChannelDescriptor(ChannelDescriptor channel) {
        WritableMap map = Arguments.createMap();

        map.putString("sid", channel.getSid());
        map.putString("friendlyName", channel.getFriendlyName());
        map.putString("uniqueName", channel.getUniqueName());
        map.putMap("attributes", jsonToWritableMap(channel.getAttributes()));
        map.putInt("messagesCount", (int) channel.getMessagesCount());
        map.putInt("membersCount", (int) channel.getMembersCount());
        map.putString("dateCreated", channel.getDateCreated().toString());
        map.putString("dateUpdated", channel.getDateUpdated().toString());
        map.putString("createdBy", channel.getCreatedBy());
        return map;
    }

    public static WritableMap User(User user) {
        WritableMap map = Arguments.createMap();

        map.putString("identity", user.getIdentity());
        map.putString("friendlyName", user.getFriendlyName());
        map.putMap("attributes", jsonToWritableMap(user.getAttributes()));
        map.putBoolean("isOnline", user.isOnline());
        map.putBoolean("isNotifiable", user.isNotifiable());

        return map;
    }

    public static WritableMap UserDescriptor(UserDescriptor userDescriptor) {
        WritableMap map = Arguments.createMap();

        map.putString("identity", userDescriptor.getIdentity());
        map.putString("friendlyName", userDescriptor.getFriendlyName());
        map.putMap("attributes", jsonToWritableMap(userDescriptor.getAttributes()));
        map.putBoolean("isOnline", userDescriptor.isOnline());
        map.putBoolean("isNotifiable", userDescriptor.isNotifiable());

        return map;
    }

    public static WritableMap Message(Message message) {
        WritableMap map = Arguments.createMap();

        map.putString("sid", message.getSid());
        map.putInt("index", (int) message.getMessageIndex());
        map.putString("author", message.getAuthor());
        map.putString("body", message.getMessageBody());
        map.putString("_channelSid", message.getChannelSid());
        map.putString("timestamp", message.getTimeStamp());

        WritableMap attributes = Arguments.createMap();
        try {
            attributes = jsonToWritableMap(message.getAttributes());
        }
        catch (JSONException e) {}
        map.putMap("attributes", attributes);
        return map;
    }

    public static WritableMap Member(Member member) {
        WritableMap map = Arguments.createMap();

        map.putString("identity", member.getIdentity());
        if (member.getLastConsumedMessageIndex() == null) {
            map.putNull("lastConsumedMessageIndex");
        }
        else {
            map.putInt("lastConsumedMessageIndex", member.getLastConsumedMessageIndex().intValue());
        }
        if (member.getLastConsumptionTimestamp() == null) {
            map.putNull("lastConsumptionTimestamp");
        }
        else {
            map.putString("lastConsumptionTimestamp", member.getLastConsumptionTimestamp());
        }

        return map;
    }

    public static WritableMap ChatClient(ChatClient client) {
        WritableMap map = Arguments.createMap();

        map.putMap("user", User(client.getUsers().getMyUser()));
        map.putString("version", client.getSdkVersion());
        map.putBoolean("isReachabilityEnabled", client.isReachabilityEnabled());

        return map;
    }

    public static WritableMap AccessManager(AccessManager accessManager) {
        WritableMap map = Arguments.createMap();

        map.putString("token", accessManager.getToken());
        map.putBoolean("isExpired", accessManager.isTokenExpired());
        map.putString("expirationDate", accessManager.getTokenExpirationDate().toString());

        return map;
    }

    public static WritableArray Channels(ArrayList<Channel> channels) {
        WritableArray array = Arguments.createArray();

        for (Channel c : channels) {
            array.pushMap(Channel(c));
        }

        return array;
    }

    public static WritableArray ChannelDescriptors(ArrayList<ChannelDescriptor> channels) {
        WritableArray array = Arguments.createArray();

        for (ChannelDescriptor c : channels) {
            array.pushMap(ChannelDescriptor(c));
        }

        return array;
    }

    public static WritableArray Members(ArrayList<Member> members) {
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

    public static WritableArray UserDescriptors(List<UserDescriptor> userDescriptors) {
        WritableArray array = Arguments.createArray();

        for (UserDescriptor u : userDescriptors) {
            array.pushMap(UserDescriptor(u));
        }

        return array;
    }

    public static WritableMap Paginator(Object paginator, String sid, String type) {
        WritableMap map = Arguments.createMap();
        WritableMap _paginator = Arguments.createMap();
        switch (type) {
            case "ChannelDescriptor":
                _paginator.putArray("items", ChannelDescriptors(((Paginator<ChannelDescriptor>)paginator).getItems()));
                _paginator.putBoolean("hasNextPage", ((Paginator<ChannelDescriptor>)paginator).hasNextPage());
                break;
            case "Member":
                _paginator.putArray("items", Members(((Paginator<Member>)paginator).getItems()));
                _paginator.putBoolean("hasNextPage", ((Paginator<Member>)paginator).hasNextPage());
                break;
            case "UserDescriptor":
                _paginator.putArray("items", UserDescriptors(((Paginator<UserDescriptor>)paginator).getItems()));
                _paginator.putBoolean("hasNextPage", ((Paginator<UserDescriptor>)paginator).hasNextPage());
                break;
        }
        map.putString("sid", sid);
        map.putString("type", type);
        map.putMap("paginator", _paginator);
        return map;
    }
}
