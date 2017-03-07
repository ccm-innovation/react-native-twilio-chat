Pod::Spec.new do |s|
  s.name         = "RCTTwilioChat"
  s.version      = "1.0.0"
  s.summary      = "React Native wrapper for Twilio Programable Chat SDKs"

  s.homepage     = "https://github.com/ccm-innovation/react-native-twilio-ip-messaging"

  s.license      = "MIT"
  s.authors      = { "Brad Bumbalough" => "bradley.bumbalough@gmail.com" }
  s.platform     = :ios, "8.1"

  s.source       = { :git => "https://github.com/ccm-innovation/react-native-twilio-ip-messaging.git" }

  s.source_files  = "RCTTwilioChat/*.{h,m}"

  s.dependency 'React'
  s.dependency 'TwilioChatClient'
  s.dependency 'TwilioAccessManager'
end
