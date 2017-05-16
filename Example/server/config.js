try {
  require('dotenv').load();
} catch (e) { }

module.exports = {
  twilio: {
    accountSid: process.env.TWILIO_ACCOUNT_SID,
    apiKey: process.env.TWILIO_API_KEY,
    apiSecret: process.env.TWILIO_API_SECRET,
    chatServiceSid: process.env.TWILIO_CHAT_SERVICE_SID
  },
  port: process.env.PORT || 3001
}
