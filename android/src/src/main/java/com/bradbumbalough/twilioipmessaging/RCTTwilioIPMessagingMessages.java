package com.bradbumbalough.twilioipmessaging;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

import com.twilio.ipmessaging.Messages;
import com.twilio.ipmessaging.Constants;
import com.twilio.ipmessaging.ErrorInfo;
import com.twilio.ipmessaging.Message;

import java.util.List;

public class RCTTwilioIPMessagingMessages extends ReactContextBaseJavaModule {

    @Override
    public String getName() {
        return "TwilioIPMessagingMembers";
    }

    private ReactApplicationContext reactContext;

    public RCTTwilioIPMessagingMessages(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    private Messages loadMessagesFromChannelSid(String sid) {
        return RCTTwilioIPMessagingClient.getInstance().client.getChannels().getChannel(sid).getMessages();
    }

    @ReactMethod
    public void getLastConsumedMessageIndex(String channelSid, Promise promise) {
        promise.resolve(loadMessagesFromChannelSid(channelSid).getLastConsumedMessageIndex());
    }

    @ReactMethod
    public void sendMessage(String channelSid, String body, final Promise promise) {
        Messages messages = loadMessagesFromChannelSid(channelSid);

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("send-message-error","Error occurred while attempting to sendMessage.");
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };

        messages.sendMessage(messages.createMessage(body), listener);
    }

    @ReactMethod
    public void removeMessage(String channelSid, Integer index, final Promise promise) {
        Messages messages = loadMessagesFromChannelSid(channelSid);

        Message messageToRemove = null;
        try {
            for (Message m : loadMessagesFromChannelSid(channelSid).getMessages()) {
                if (m.getMessageIndex() == index) {
                    messageToRemove = m;
                    break;
                }
            }
        }
        catch (Exception e) {
            promise.reject("remove-message-error","Error occurred while attempting to remove message.");
        }

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("remove-message-error","Error occurred while attempting to remove message.");
            }

            @Override
            public void onSuccess() {
                promise.resolve(true);
            }
        };

        loadMessagesFromChannelSid(channelSid).removeMessage(messageToRemove, listener);
    }

    @ReactMethod
    public void getLastMessages(String channelSid, Integer count, final Promise promise) {

        Constants.CallbackListener<List<Message>> listener = new Constants.CallbackListener<List<Message>>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-last-message-error","Error occurred while attempting to getLastMessage.");
            }

            public void onSuccess(List<Message> messages) {
                promise.resolve(RCTConvert.Messages(messages));
            }
        };

        loadMessagesFromChannelSid(channelSid).getLastMessages(count, listener);
    }

    @ReactMethod
    public void getMessagesAfter(String channelSid, Integer index, Integer count, final Promise promise) {

        Constants.CallbackListener<List<Message>> listener = new Constants.CallbackListener<List<Message>>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-messages-after-error","Error occurred while attempting to getMessagesAfter.");
            }

            public void onSuccess(List<Message> messages) {
                promise.resolve(RCTConvert.Messages(messages));
            }
        };

        loadMessagesFromChannelSid(channelSid).getMessagesAfter(index, count, listener);
    }

    @ReactMethod
    public void getMessagesBefore(String channelSid, Integer index, Integer count, final Promise promise) {

        Constants.CallbackListener<List<Message>> listener = new Constants.CallbackListener<List<Message>>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-messages-before-error","Error occurred while attempting to getMessagesBefore.");
            }

            public void onSuccess(List<Message> messages) {
                promise.resolve(RCTConvert.Messages(messages));
            }
        };

        loadMessagesFromChannelSid(channelSid).getMessagesBefore(index, count, listener);
    }

    @ReactMethod
    public void getMessage(String channelSid, Integer index, final Promise promise) {
        Constants.CallbackListener<List<Message>> listener = new Constants.CallbackListener<List<Message>>() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("get-message-error","Error occurred while attempting to getMessage.");
            }

            public void onSuccess(List<Message> messages) {
                promise.resolve(RCTConvert.Message(messages.get(0)));
            }
        };

        loadMessagesFromChannelSid(channelSid).getMessagesAfter(index, 1, listener);
    }

    @ReactMethod
    public void setLastConsumedMessageIndex(String channelSid, Integer index) {
        loadMessagesFromChannelSid(channelSid).setLastConsumedMessageIndex(index);
    }

    @ReactMethod
    public void advanceLastConsumedMessageIndex(String channelSid, Integer index) {
        loadMessagesFromChannelSid(channelSid).advanceLastConsumedMessageIndex(index);
    }

    @ReactMethod
    public void setAllMessagesConsumed(String channelSid) {
        loadMessagesFromChannelSid(channelSid).setAllMessagesConsumed();
    }

    // Message instance method

    @ReactMethod
    public void updateBody(String channelSid, Integer index, String body, final Promise promise) {;

        Constants.StatusListener listener = new Constants.StatusListener() {
            @Override
            public void onError(ErrorInfo errorInfo) {
                super.onError(errorInfo);
                promise.reject("update-body-error","Error occurred while attempting to updateBody.");
            }

            public void onSuccess() {
                promise.resolve(true);
            }
        };

        try {
            for (Message m : loadMessagesFromChannelSid(channelSid).getMessages()) {
                if (m.getMessageIndex() == index) {
                    m.updateMessageBody(body, listener);
                    break;
                }
            }
        }
        catch (Exception e) {
            promise.reject("update-body-error","Error occurred while attempting to updateBody.");
        }
    }

}