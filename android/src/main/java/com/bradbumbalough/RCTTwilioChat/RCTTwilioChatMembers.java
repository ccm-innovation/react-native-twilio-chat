package com.bradbumbalough.RCTTwilioChat;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.twilio.chat.Member;
import com.twilio.chat.StatusListener;
import com.twilio.chat.ErrorInfo;
import com.twilio.chat.UserDescriptor;
import com.twilio.chat.User;
import com.twilio.chat.Members;
import com.twilio.chat.CallbackListener;
import com.twilio.chat.Channel;
import com.twilio.chat.Paginator;

import java.sql.Array;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;


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
    public void getMembers(final String channelSid, final Promise promise) {
        loadMembersFromChannelSid(channelSid, new CallbackListener<Members>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-members-error","Error occurred while attempting to get members on channel.");
            }

            @Override
            public void onSuccess(Members members) {
                try {
                    // There is a difference between this method and the iOS SDK method getMembers.
                    // The iOS method is async and uses MemberPaginator
                    // iOS SDK: - (void)membersWithCompletion:(TCHMemberPaginatorCompletion)completion
                    // https://media.twiliocdn.com/sdk/ios/chat/releases/1.0.0/docs/Classes/TCHMembers.html#//api/name/membersWithCompletion:
                    // Android SDK: public java.util.List<Member> getMembersList()
                    // https://media.twiliocdn.com/sdk/android/chat/releases/1.0.0/docs/com/twilio/chat/Members.html#getMembersList--
                    // Carl Olivier from Twilio team said this change will be addressed soon, so
                    // this code is temporary
                    List<Member> membersArr = members.getMembersList();
                    WritableArray memberItems = Arguments.createArray();
                    for(Member m : membersArr) {
                        memberItems.pushMap(RCTConvert.Member(m));
                    }
                    WritableMap map = Arguments.createMap();
                    map.putString("sid", channelSid);
                    map.putString("type", "Member");
                    map.putArray("items", memberItems);
                    promise.resolve(map);
                }
                catch (Exception e) {
                    e.printStackTrace();
                    promise.reject("get-members-error","Error occurred while attempting to get members on channel.");
                }
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
                    if (m.getIdentity() == identity) {
                        memberToDelete = m;
                    }
                }
                members.remove(memberToDelete, new StatusListener() {
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

    // Member instance method
    @ReactMethod
    public void userDescriptor(String channelSid, final String identity, final Promise promise){
      loadMembersFromChannelSid(channelSid, new CallbackListener<Members>() {
        @Override
        public void onError(ErrorInfo errorInfo) {
            super.onError(errorInfo);
            promise.reject("get-members-error","Error occurred while attempting to get members on channel.");
        }

        @Override
        public void onSuccess(Members members) {
          Member member = members.getMember(identity);
          member.getUserDescriptor(new CallbackListener<UserDescriptor>() {

            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-user-descriptor","Error occurred while attempting to get user descriptions.");
            }

            @Override
            public void onSuccess(final UserDescriptor userDescriptor) {
                promise.resolve(RCTConvert.UserDescriptor(userDescriptor));
            }
          });
        }
      });
    }

    @ReactMethod
    public void subscribedUser(String channelSid, final String identity, final Promise promise){
      loadMembersFromChannelSid(channelSid, new CallbackListener<Members>() {
        @Override
        public void onError(ErrorInfo errorInfo) {
            super.onError(errorInfo);
            promise.reject("get-members-error","Error occurred while attempting to get members on channel.");
        }

        @Override
        public void onSuccess(Members members) {
          Member member = members.getMember(identity);
          member.getAndSubscribeUser(new CallbackListener<User>() {

            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-user","Error occurred while attempting to get user.");
            }

            @Override
            public void onSuccess(User user) {
                promise.resolve(RCTConvert.User(user));
            }
          });
        }
      });
    }
}
