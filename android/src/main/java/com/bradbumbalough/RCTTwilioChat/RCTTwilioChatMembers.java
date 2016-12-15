package com.bradbumbalough.RCTTwilioChat;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import com.twilio.chat.Member;
import com.twilio.chat.Constants;
import com.twilio.chat.ErrorInfo;
import com.twilio.chat.Members;

public class RCTTwilioChatMembers extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioChatMembers";
    }


    public RCTTwilioChatMembers(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    private Members loadMembersFromChannelSid(String sid) {
        return RCTTwilioChatClient.getInstance().client.getChannels().getChannel(sid).getMembers();
    }

    @ReactMethod
    public void getMembers(String channelSid, Promise promise) {
        promise.resolve(RCTConvert.Members(loadMembersFromChannelSid(channelSid).getMembers()));
    }

    @ReactMethod
    public void add(String channelSid, String identity, final Promise promise) {

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("add-error","Error occurred while attempting to add user to channel.");
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
                promise.reject("invite-error","Error occurred while attempting to invite user to channel.");
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
                promise.reject("remove-error","Error occurred while attempting to remove user from channel.");
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

}
