# Example App

Run `npm install` (in this directory) and then `pod install` (for iOS) to bring in the xcode dependencies. 

This is an example app using [React Native Gifted Messenger](https://github.com/FaridSafi/react-native-gifted-messenger).

![](https://raw.githubusercontent.com/ccm-innovation/react-native-twilio-chat/master/Example/capture.png)

You'll need to run a server locally to generate the access_tokens. I used a version of the [Twilio Chat Quickstart](https://www.twilio.com/docs/api/chat/guides/quickstart-js#download), modified to take an identity param in the `/token` route.

```JavaScript
app.get('/token', function(request, response) {
    var appName = 'TwilioChatDemo';
    var identity = request.query.identity || randomUsername();
    var deviceId = request.query.device;
    ...
```
