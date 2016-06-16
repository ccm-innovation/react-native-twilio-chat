# Example App

Run `pod install` to bring in the xcode dependencies. 

This is an example app using [React Native Gifted Messenger](https://github.com/FaridSafi/react-native-gifted-messenger).

![](https://raw.githubusercontent.com/ccm-innovation/react-native-twilio-ip-messaging/master/Example/capture.png)

You'll need to run a server locally to generate the access_tokens. I used a version of the [IP Messaging Quickstart](https://www.twilio.com/docs/api/ip-messaging/guides/quickstart-js#download), modified to take an identity param in the `/token` route.

```JavaScript
app.get('/token', function(request, response) {
    var appName = 'TwilioChatDemo';
    var identity = request.query.identity || randomUsername();
    var deviceId = request.query.device;
    ...
```