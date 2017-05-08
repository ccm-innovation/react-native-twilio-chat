Pod::Spec.new do |s|
  s.name         = "RCTTwilioChat"
  s.version      = "0.1.1"
  s.summary      = "React Native wrapper for Twilio Programable Chat SDKs"

  s.homepage     = "https://github.com/ccm-innovation/react-native-twilio-chat"

  s.license      = "MIT"
  s.authors      = { "Brad Bumbalough" => "bradley.bumbalough@gmail.com" }
  s.platform     = :ios, "8.1"

  s.source       = { :git => "https://github.com/ccm-innovation/react-native-twilio-chat.git" }

  s.source_files  = "RCTTwilioChat/*.{h,m}"

  s.dependency 'React'
  s.dependency 'TwilioChatClient'
  s.dependency 'TwilioAccessManager'
end
