package com.bradbumbalough.RCTTwilioChat;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import com.twilio.chat.Member;
import com.twilio.chat.StatusListener;
import com.twilio.chat.ErrorInfo;
import com.twilio.chat.Members;
import com.twilio.chat.CallbackListener;
import com.twilio.chat.Channel;
import com.twilio.chat.Paginator;

import java.sql.Array;
import java.util.ArrayList;


public class RCTTwilioChatMembers extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioChatMembers";
    }


    public RCTTwilioChatMembers(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    private void loadMembersFromChannelSid(String sid, final CallbackListener<Members> callbackListener) {
        RCTTwilioChatClient.getInstance().client.getChannels().getChannel(sid, new CallbackListener<Channel>() {
            @Override
            public void onSuccess(final Channel channel) {
                callbackListener.onSuccess(channel.getMembers());
            };

            @Override
            public void onError(final ErrorInfo errorInfo){
                callbackListener.onError(errorInfo);
            }
        });
    }

    @ReactMethod
    public void getMembers(String channelSid, final Promise promise) {
        loadMembersFromChannelSid(channelSid, new CallbackListener<Members>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-members-error","Error occurred while attempting to get members on channel.");
            }

            @Override
            public void onSuccess(Members members) {
                members.getMembers(new CallbackListener<Paginator<Member>>() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("get-members-error","Error occurred while attempting to get members on channel.");
                    }

                    @Override
                    public void onSuccess(Paginator<Member> memberPaginator) {
                        String uuid = RCTTwilioChatPaginator.setPaginator(memberPaginator);
                        promise.resolve(RCTConvert.Paginator(memberPaginator, uuid, "Member"));
                    }
                });
            }
        });
    }

    @ReactMethod
    public void add(String channelSid, final String identity, final Promise promise) {
        loadMembersFromChannelSid(channelSid, new CallbackListener<Members>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("add-error","Error occurred while attempting to add user to channel.");
            }

            @Override
            public void onSuccess(Members members) {
                members.addByIdentity(identity, new StatusListener() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("add-error","Error occurred while attempting to add user to channel.");
                    }

                    @Override
                    public void onSuccess() {
                        promise.resolve(true);
                    }
                });
            }
        });
    }

    @ReactMethod
    public void invite(String channelSid, final String identity, final Promise promise) {
        loadMembersFromChannelSid(channelSid, new CallbackListener<Members>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("invite-error","Error occurred while attempting to invite user to channel.");
            }

            @Override
            public void onSuccess(Members members) {
                members.inviteByIdentity(identity, new StatusListener() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("invite-error","Error occurred while attempting to invite user to channel.");
                    }

                    @Override
                    public void onSuccess() {
                        promise.resolve(true);
                    }
                });
            }
        });
    }

    @ReactMethod
    public void remove(String channelSid, final String identity, final String paginatorSid, final Promise promise) {
        loadMembersFromChannelSid(channelSid, new CallbackListener<Members>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("remove-error","Error occurred while attempting to remove user from channel.");
            }

            @Override
            public void onSuccess(Members members) {
                RCTTwilioChatPaginator _paginator = RCTTwilioChatPaginator.getInstance();
                ArrayList<Member> memberList = ((Paginator<Member>)_paginator.paginators.get(paginatorSid)).getItems();
                Member memberToDelete = null;
                for (Member m : memberList) {
                    if (m.getUserInfo().getIdentity() == identity) {
                        memberToDelete = m;
                    }
                }
                members.removeMember(memberToDelete, new StatusListener() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("remove-error","Error occurred while attempting to remove user from channel.");
                    }

                    @Override
                    public void onSuccess() {
                        promise.resolve(true);
                    }
                });
            }
        });
    }

}
