package com.bradbumbalough.twilioipmessaging;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import com.twilio.ipmessaging.Member;
import com.twilio.ipmessaging.Constants;
import com.twilio.ipmessaging.ErrorInfo;
import com.twilio.ipmessaging.Members;

public class RCTTwilioIPMessagingMembers extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioIPMessagingMembers";
    }

    private ReactApplicationContext reactContext;

    public RCTTwilioIPMessagingMembers(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    private Members loadMembersFromChannelSid(String sid) {
        return RCTTwilioIPMessagingClient.getInstance().client.getChannels().getChannel(sid).getMembers();
    }

    @ReactMethod
    public void getMembers(String channelSid, Promise promise) {
        promise.resolve(loadMembersFromChannelSid(channelSid).getMembers());
    }

    @ReactMethod
    public void add(String channelSid, String identity, final Promise promise) {

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
        loadMembersFromChannelSid(channelSid).addByIdentity(identity, listener);
    }

    @ReactMethod
    public void invite(String channelSid, String identity, final Promise promise) {

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
        loadMembersFromChannelSid(channelSid).inviteByIdentity(identity, listener);
    }

    @ReactMethod
    public void remove(String channelSid, String identity, final Promise promise) {

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
        Member[] members = loadMembersFromChannelSid(channelSid).getMembers();
        Member memberToDelete = null;

        for (Member m : members) {
            if (m.getUserInfo().getIdentity() == identity) {
                memberToDelete = m;
                break;
            }
        }
        loadMembersFromChannelSid(channelSid).removeMember(memberToDelete, listener);
    }

    @ReactMethod
    public void getMember(String channelSid, String identity, final Promise promise) {
        Member[] members = loadMembersFromChannelSid(channelSid).getMembers();

        for (Member m : members) {
            if (m.getUserInfo().getIdentity() == identity) {
                promise.resolve(m);
                break;
            }
        }
    }

}
