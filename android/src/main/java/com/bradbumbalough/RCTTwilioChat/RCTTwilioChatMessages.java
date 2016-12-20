package com.bradbumbalough.RCTTwilioChat;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableMap;

import com.twilio.chat.Messages;
import com.twilio.chat.Constants;
import com.twilio.chat.ErrorInfo;
import com.twilio.chat.Message;

import java.util.List;

import org.json.JSONObject;

public class RCTTwilioChatMessages extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioChatMessages";
    }


    public RCTTwilioChatMessages(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    private void loadMessagesFromChannelSid(String sid, CallbackListener<Messages> callbackListener) {
        RCTTwilioChatClient.getInstance().client.getChannels().getChannel(sid, new CallbackListener<Channel>() {
            @Override
            public void onSuccess(final Channel channel) {
                callbackListener.onSuccess(channel.getMessages());
            }

            @Override
            public void onError(final ErrorInfo errorInfo) {
                callback.onError(errorInfo);
            }
        });
    }

    @ReactMethod
    public void getLastConsumedMessageIndex(String channelSid, Promise promise) {
        loadMessagesFromChannelSid(channelSid new CallbackListener<Messages>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-last-consumped-message-index","Error occurred while attempting to getLastConsumedMessageIndex.");
            }

            @Override
            public void onSuccess(Messages messages) {
                Long lastConsumedMessageIndex = messages.getLastConsumedMessageIndex();
                if (lastConsumedMessageIndex != null) {
                    promise.resolve(Integer.valueOf(lastConsumedMessageIndex.intValue()));
                } else {
                    promise.resolve(null);
                }
            }
        });
    }

    @ReactMethod
    public void sendMessage(String channelSid, String body, final Promise promise) {
        loadMessagesFromChannelSid(channelSid, new CallbackListener<Messages>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("send-message-error","Error occurred while attempting to sendMessage.");
            }

            @Override
            public void onSuccess(Messages messages) {
                messages.sendMessage(body, new Constants.StatusListener() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("send-message-error","Error occurred while attempting to sendMessage.");
                    }

                    @Override
                    public void onSuccess() {
                        promise.resolve(true);
                    }
                })
            }
        });
    }

    @ReactMethod
    public void removeMessage(String channelSid, Integer index, final Promise promise) {
        loadMessagesFromChannelSid(channelSid, new CallbackListener<Messages>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("remove-message-error","Error occurred while attempting to remove message.");
            }

            @Override
            public void onSuccess(Messages messages) {
                messages.getMessageByIndex(index, new CallbackListener<Message>() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("remove-message-error","Error occurred while attempting to remove message.");
                    }

                    @Override
                    public void onSuccess(Message message) {
                        messages.removeMessage(message, new Constants.StatusListener() {
                            @Override
                            public void onError(ErrorInfo errorInfo) {
                                super.onError(errorInfo);
                                promise.reject("remove-message-error","Error occurred while attempting to remove message.");
                            }

                            @Override
                            public void onSuccess() {
                                promise.resolve(true);
                            }
                        });
                    }
                });
            }
        });
    }

    @ReactMethod
    public void getLastMessages(String channelSid, Integer count, final Promise promise) {
        loadMessagesFromChannelSid(channelSid, new CallbackListener<Messages>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-last-messages-error","Error occurred while attempting to getLastMessages.");
            }

            public void onSuccess(Messages messages) {
                messages.getLastMessages(count, new CallbackListener<List<Message>>() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("get-last-messages-error","Error occurred while attempting to getLastMessages.");
                    }

                    @Override
                    public void onSuccess(List<Message> _messages) {
                        promise.resolve(RCTConvert.Messages(_messages));
                    }
                })
            }
        });
    }

    @ReactMethod
    public void getMessagesAfter(String channelSid, Integer index, Integer count, final Promise promise) {
        loadMessagesFromChannelSid(channelSid, new CallbackListener<Messages>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-messages-after-error","Error occurred while attempting to getMessagesAfter.");
            }

            public void onSuccess(Messages messages) {
                messages.getMessagesAfter(index, count, new CallbackListener<List<Message>>() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("get-messages-after-error","Error occurred while attempting to getMessagesAfter.");
                    }

                    @Override
                    public void onSuccess(List<Message> _messages) {
                        promise.resolve(RCTConvert.Messages(_messages));
                    }
                });
            }
        });
    }

    @ReactMethod
    public void getMessagesBefore(String channelSid, Integer index, Integer count, final Promise promise) {
        loadMessagesFromChannelSid(channelSid, new CallbackListener<Messages>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-messages-before-error","Error occurred while attempting to getMessagesBefore.");
            }

            public void onSuccess(Messages messages) {
                messages.getMessagesBefore(index, count, new CallbackListener<List<Message>>() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("get-messages-before-error","Error occurred while attempting to getMessagesBefore.");
                    }

                    @Override
                    public void onSuccess(List<Message> _messages) {
                        promise.resolve(RCTConvert.Messages(_messages));
                    }
                });
            }
        });
    }

    @ReactMethod
    public void getMessage(String channelSid, Integer index, final Promise promise) {
        loadMessagesFromChannelSid(channelSid, new CallbackListener<Messages>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-message-error","Error occurred while attempting to getMessage.");
            }

            public void onSuccess(Messages messages) {
                messages.getMessageByIndex(index, new CallbackListener<Message>() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("get-message-error","Error occurred while attempting to getMessage.");
                    }

                    @Override
                    public void onSuccess(Message message) {
                        promise.resolve(RCTConvert.Message(message));
                    }
                });
            }
        });
    }

    @ReactMethod
    public void setLastConsumedMessageIndex(String channelSid, Integer index) {
        loadMessagesFromChannelSid(channelSid, new CallbackListener<Messages>() {
            @Override
            public void onSuccess(Messages messages) {
                messages.setLastConsumedMessageIndex(index);
            }
        });
    }

    @ReactMethod
    public void advanceLastConsumedMessageIndex(String channelSid, Integer index) {
        loadMessagesFromChannelSid(channelSid, new CallbackListener<Messages>() {
            @Override
            public void onSuccess(Messages messages) {
                messages.advanceLastConsumedMessageIndex(index);
            }
        });
    }

    @ReactMethod
    public void setAllMessagesConsumed(String channelSid) {
        loadMessagesFromChannelSid(channelSid, new CallbackListener<Messages>() {
            @Override
            public void onSuccess(Messages messages) {
                messages.setAllMessagesConsumed(index);
            }
        });
    }

    // Message instance method

    @ReactMethod
    public void updateBody(String channelSid, Integer index, String body, final Promise promise) {;
        loadMessagesFromChannelSid(channelSid, new CallbackListener<Messages>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("update-body-error","Error occurred while attempting to updateBody.");
            }

            public void onSuccess(Messages messages) {
                messages.getMessageByIndex(index, new CallbackListener<Message>() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("update-body-error","Error occurred while attempting to updateBody.");
                    }

                    @Override
                    public void onSuccess(Message message) {
                        message.updateMessageBody(body, new Constants.StatusListener() {
                            @Override
                            public void onError(ErrorInfo errorInfo) {
                                super.onError(errorInfo);
                                promise.reject("update-body-error","Error occurred while attempting to updateBody.");
                            }
                            
                            @Override
                            public void onSuccess() {
                                promise.resolve(true);
                            }
                        });
                    }
                });
            }
        });
    }

    @ReactMethod
    public void setAttributes(String channelSid, Integer index, ReadableMap attributes, final Promise promise) {
        loadMessagesFromChannelSid(channelSid, new CallbackListener<Messages>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("set-attributes-error", "Error occurred while attempting to setAttributes on Message.");
            }

            public void onSuccess(Messages messages) {
                messages.getMessageByIndex(index, new CallbackListener<Message>() {
                    @Override
                    public void onError(ErrorInfo errorInfo) {
                        super.onError(errorInfo);
                        promise.reject("set-attributes-error", "Error occurred while attempting to setAttributes on Message.");
                    }

                    @Override
                    public void onSuccess(Message message) {
                        message.setAttributes(json, new Constants.StatusListener() {
                            @Override
                            public void onError(ErrorInfo errorInfo) {
                                super.onError(errorInfo);
                                promise.reject("set-attributes-error", "Error occurred while attempting to setAttributes on Message.");
                            }

                            @Override
                            public void onSuccess() {
                                promise.resolve(true);
                            }
                        });
                    }
                });
            }
        });
    }

}
