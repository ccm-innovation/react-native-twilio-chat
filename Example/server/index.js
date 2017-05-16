const config     = require('./config');
const express    = require('express');
const bodyParser = require('body-parser');
const twilio     = require('twilio');

const AccessToken = twilio.jwt.AccessToken;
const ChatGrant = AccessToken.IpMessagingGrant;

const app = new express();
app.use(bodyParser.json());

app.post('/token/:identity', (request, response) => {
  const identity = request.params.identity;
  const accessToken = new AccessToken(config.twilio.accountSid, config.twilio.apiKey, config.twilio.apiSecret);
  const chatGrant = new ChatGrant({
    serviceSid: config.twilio.chatServiceSid,
    endpointId: `${identity}:browser`
  });
  accessToken.addGrant(chatGrant);
  accessToken.identity = identity;
  response.set('Content-Type', 'application/json');
  response.send(JSON.stringify({
    token: accessToken.toJwt(),
    identity: identity
  }));
})

app.listen(config.port, () => {
  console.log(`Application started at localhost:${config.port}`);
});
