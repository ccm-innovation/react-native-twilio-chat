Pod::Spec.new do |s|
  s.name         = "RCTTwilioIPMessaging"
  s.version      = "0.1.1"
  s.summary      = "React Native wrapper for Twilio IP Messaging SDKs"

  s.homepage     = "https://github.com/ccm-innovation/react-native-twilio-ip-messaging"

  s.license      = "MIT"
  s.authors      = { "Brad Bumbalough" => "bradley.bumbalough@gmail.com" }
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/ccm-innovation/react-native-twilio-ip-messaging.git" }

  s.source_files  = "RCTTwilioIPMessaging/*.{h,m}"

  s.dependency 'React'
  s.dependency 'TwilioIPMessagingClient'
end
