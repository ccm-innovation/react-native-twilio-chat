package com.bradbumbalough.RCTTwilioChat;

import android.support.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableMap;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.twilio.chat.Channel;
import com.twilio.chat.ChannelListener;
import com.twilio.chat.ChannelDescriptor;
import com.twilio.chat.ErrorInfo;
import com.twilio.chat.Channels;
import com.twilio.chat.Member;
import com.twilio.chat.StatusListener;
import com.twilio.chat.Message;
import com.twilio.chat.CallbackListener;
import com.twilio.chat.Paginator;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.lang.Integer;

import org.json.JSONObject;


public class RCTTwilioChatChannels extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioChatChannels";
    }

    private ReactApplicationContext reactContext;
    private Map<String,ChannelListener> channelListeners = new HashMap<String, ChannelListener>();

    public RCTTwilioChatChannels(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    private void sendEvent(String eventName, @Nullable WritableMap params) {
        this.reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    private ChannelListener generateListener(final Channel channel) {
        final String channelSid = channel.getSid();

        ChannelListener listener = new ChannelListener() {
            @Override
            public void onMessageAdded(Message message) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("message", RCTConvert.Message(message));
                sendEvent("chatClient:channel:messageAdded", map);
            }

            @Override
            public void onMessageUpdated(Message message) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("message", RCTConvert.Message(message));

                sendEvent("chatClient:channel:messageChanged", map);
            }

            @Override
            public void onMessageDeleted(Message message) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("message", RCTConvert.Message(message));

                sendEvent("chatClient:channel:messageDeleted", map);
            }

            @Override
            public void onMemberAdded(Member member) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("member", RCTConvert.Member(member));

                sendEvent("chatClient:channel:memberJoined", map);
            }

            @Override
            public void onMemberUpdated(Member member) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("member", RCTConvert.Member(member));

                sendEvent("chatClient:channel:memberChanged", map);
            }

            @Override
            public void onMemberDeleted(Member member) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("member", RCTConvert.Member(member));

                sendEvent("chatClient:channel:memberLeft", map);
            }

            @Override
            public void onTypingStarted(Member member) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("member", RCTConvert.Member(member));

                sendEvent("chatClient:typingStartedOnChannel", map);
            }

            @Override
            public void onTypingEnded(Member member) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putMap("member", RCTConvert.Member(member));

                sendEvent("chatClient:typingEndedOnChannel", map);
            }

            @Override
            public void onSynchronizationChanged(Channel channel) {
                WritableMap map = Arguments.createMap();
                map.putString("channelSid", channelSid);
                map.putString("status", channel.getSynchronizationStatus().toString());

                sendEvent("chatClient:channel:synchronizationStatusChanged", map);
            }
        };

        return listener;
    }

    private Channels channels() {
        return RCTTwilioChatClient.getInstance().client.getChannels();
    }

    private void createListener(Channel channel) {
        String sid = channel.getSid();
        if (!channelListeners.containsKey(sid)) {
            ChannelListener listener = generateListener(channel);
            channel.addListener(listener);
            channelListeners.put(sid, listener);
        }
    }

    public void loadChannelFromSid(final String sid, final CallbackListener<Channel> callback) {
        channels().getChannel(sid, new CallbackListener<Channel>() {
            @Override
            public void onSuccess(final Channel channel) {
                createListener(channel);
                callback.onSuccess(channel);
            };

            @Override
            public void onError(final ErrorInfo errorInfo){
                callback.onError(errorInfo);
            }

        });
    }

    @ReactMethod
    public void getUserChannels(final Promise promise) {
        channels().getUserChannelsList(new CallbackListener<Paginator<ChannelDescriptor>>() {
            @Override
            public void onError(final ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-user-channels-error", "Error occurred while attempting to getUserChannels.");
            }

            @Override
            public void onSuccess(final Paginator<ChannelDescriptor> channelPaginator) {
                String uuid = RCTTwilioChatPaginator.setPaginator(channelPaginator);
                promise.resolve(RCTConvert.Paginator(channelPaginator, uuid, "ChannelDescriptor"));
            }
        });
    }

    @ReactMethod
    public void getSubscribedChannels(final Promise promise) {
        List<Channel> list = channels().getSubscribedChannels();
        promise.resolve(RCTConvert.Channels(new ArrayList<Channel>(list)));
    }

    @ReactMethod
    public void getPublicChannels(final Promise promise) {
        channels().getPublicChannelsList(new CallbackListener<Paginator<ChannelDescriptor>>() {
            @Override
            public void onError(final ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-public-channels-error", "Error occurred while attempting to getPublicChannels.");
            }

            @Override
            public void onSuccess(final Paginator<ChannelDescriptor> channelDescriptorPaginator) {
                String uuid = RCTTwilioChatPaginator.setPaginator(channelDescriptorPaginator);
                promise.resolve(RCTConvert.Paginator(channelDescriptorPaginator, uuid, "ChannelDescriptor"));
            }
        });
    }

    @ReactMethod
    public void createChannel(ReadableMap options, final Promise promise) {
        final JSONObject attributes = RCTConvert.readableMapToJson(options.getMap("attributes"));
        final String uniqueName = options.getString("uniqueName");
        String friendlyName = options.getString("friendlyName");
        Channel.ChannelType type = (options.getString("type").compareTo("PRIVATE") == 0) ? Channel.ChannelType.PRIVATE : Channel.ChannelType.PUBLIC;

        channels().channelBuilder()
                .withUniqueName(uniqueName)
                .withFriendlyName(friendlyName)
                .withType(type)
                .withAttributes(attributes)
                .build(new CallbackListener<Channel>() {
                    @Override
                    public void onError(final ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("create-channel-error", "Error occurred while attempting to createChannel.");
                    }

                    @Override
                    public void onSuccess(final Channel newChannel) {
                        promise.resolve(RCTConvert.Channel(newChannel));
                    }
                });
    }

    @ReactMethod
    public void getChannel(String sid, final Promise promise) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onError(final ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-full-channel-object-error", "Error occured while attempting to get full channel object.");
            }

            @Override
            public void onSuccess(final Channel channel) {
                promise.resolve(RCTConvert.Channel(channel));
            }
        });
    }

    // Channel Instance Methods

    @ReactMethod
    public void setAttributes(String sid, final ReadableMap attributes, final Promise promise) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("set-attributes-error", "Error occurred while attempting to setAttributes on channel.");
            }

            @Override
            public void onSuccess(Channel channel) {
                JSONObject json = RCTConvert.readableMapToJson(attributes);
                channel.setAttributes(json, new StatusListener() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("set-attributes-error", "Error occurred while attempting to setAttributes on channel.");
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
    public void setFriendlyName(String sid, final String friendlyName, final Promise promise) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("set-friendly-name-error", "Error occurred while attempting to setFriendlyName on channel.");
            }

            @Override
            public void onSuccess(Channel channel) {
                channel.setFriendlyName(friendlyName, new StatusListener() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("set-friendly-name-error", "Error occurred while attempting to setFriendlyName on channel.");
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
    public void setUniqueName(String sid, final String uniqueName, final Promise promise) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("set-unique-name-error", "Error occurred while attempting to setUniqueName on channel.");
            }

            @Override
            public void onSuccess(Channel channel) {
                channel.setUniqueName(uniqueName, new StatusListener() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("set-unique-name-error", "Error occurred while attempting to setUniqueName on channel.");
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
    public void join(String sid, final Promise promise) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("join-error", "Error occurred while attempting to join channel.");
            }

            @Override
            public void onSuccess(Channel channel) {
                channel.join(new StatusListener() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("join-error", "Error occurred while attempting to join channel.");
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
    public void declineInvitation(String sid, final Promise promise) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("decline-invitation-error", "Error occured while attempting to decline the invitation to join the channel.");
            }

            @Override
            public void onSuccess(Channel channel) {
                channel.declineInvitation(new StatusListener() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("decline-invitation-error", "Error occured while attempting to decline the invitation to join the channel.");
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
    public void leave(String sid, final Promise promise) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("leave-channel-error", "Error occurred while attempting to leave channel.");
            }

            @Override
            public void onSuccess(Channel channel) {
                channel.leave(new StatusListener() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("leave-channel-error", "Error occurred while attempting to leave channel.");
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
    public void destroy(String sid, final Promise promise) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("destroy-channel-error", "Error occurred while attempting to delete channel.");
            }

            @Override
            public void onSuccess(Channel channel) {
                channel.destroy(new StatusListener() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("destroy-channel-error", "Error occurred while attempting to delete channel.");
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
    public void typing(String sid) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onSuccess(Channel channel) {
                channel.typing();
            }
        });
    }

    @ReactMethod
    public void getUnconsumedMessagesCount(String sid, final Promise promise) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-unconsumed-messages-count-error", "Error occurred while attempting to getUnconsumedMessagesCount.");
            }

            @Override
            public void onSuccess(Channel channel) {
                channel.getUnconsumedMessagesCount(new CallbackListener<Long>() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("get-unconsumed-messages-count-error", "Error occurred while attempting to getUnconsumedMessagesCount.");
                    }

                    @Override
                    public void onSuccess(Long count) {
                        promise.resolve(Long.toString(count));
                    }
                });
            }
        });
    }

    @ReactMethod
    public void getMessagesCount(String sid, final Promise promise) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-messages-count-error", "Error occured while attempting to get channel messages count.");
            }

            @Override
            public void onSuccess(Channel channel) {
                channel.getMessagesCount(new CallbackListener<Long>() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("get-messages-count-error", "Error occured while attempting to get channel messages count.");
                    }

                    @Override
                    public void onSuccess(Long count) {
                        promise.resolve(Long.toString(count));
                    }
                });
            }
        });
    }

    @ReactMethod
    public void getMembersCount(String sid, final Promise promise) {
        loadChannelFromSid(sid, new CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-members-count-error", "Error occurred while attempting to get channel members count.");
            }

            @Override
            public void onSuccess(Channel channel) {
                channel.getMembersCount(new CallbackListener<Long>() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("get-members-count-error", "Error occurred while attempting to get channel members count.");
                    }

                    @Override
                    public void onSuccess(Long count) {
                        promise.resolve(Long.toString(count));
                    }
                });
            }
        });
    }

    @ReactMethod
    public void shutdown() {
      channelListeners.clear();
    }


    @ReactMethod
    public void getMember(String channelSid, final String identity, final Promise promise) {
        loadChannelFromSid(channelSid, new CallbackListener<Channel>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                promise.reject("get-member-error", "Error occured while attempting to get channel member");
            }

            @Override
            public void onSuccess(Channel channel) {
                try {
                    Member m = channel.getMembers().getMember(identity);
                    promise.resolve(RCTConvert.Member(m));
                }
                catch (Exception e) {
                    e.printStackTrace();
                    promise.reject("get-member-error", "Error occured while attempting to get channel member.");
                }
            }
        });
    }
}
