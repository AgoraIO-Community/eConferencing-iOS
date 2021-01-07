# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

workspace 'VideoConference.xcworkspace'

target 'VideoConference' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'YYModel'
  pod "IQKeyboardManager"
#  pod 'AgoraRoom', :path => '/Users/zyp/Agora/AgoraRoom/AgoraRoom.podspec'
end

target 'AgoraRoom' do
  use_frameworks!
  pod 'AFNetworking', '4.0.1'
  pod 'AgoraRtm_iOS', '1.4.2'
  pod 'CocoaLumberjack', '3.6.1'
  pod 'AliyunOSSiOS'
  pod 'YYModel'
  pod 'AgoraRte', :path => '/Users/zyp/Agora/common-scene-sdk/iOS/AgoraRte.podspec'
end

target "WhiteModule" do
  project 'Modules/WhiteModule/WhiteModule.xcodeproj'
  pod 'Whiteboard', '2.6.4'
end

# replay
target "ReplayKitModule" do
  project 'Modules/ReplayKitModule/ReplayKitModule.xcodeproj'
  pod 'Whiteboard', '2.6.4'
end
target "ReplayKitUIModule" do
  project 'Modules/ReplayKitUIModule/ReplayKitUIModule.xcodeproj'
end

