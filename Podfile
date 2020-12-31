# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

workspace 'VideoConference.xcworkspace'

target 'VideoConference' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'YYModel'
  pod "IQKeyboardManager"
  pod 'AgoraRoom', :path => '/Users/zyp/Agora/AgoraRoom/AgoraRoom.podspec'
end

#target "AgoraRoom" do
#  project 'Modules/AgoraRoom/AgoraRoom.xcodeproj'
#
#  # Media
##  pod 'AgoraRtcEngine_iOS', '2.9.0.102'
#  pod 'AgoraRtm_iOS', '1.2.2'
#
#  # HTTP
#  pod 'AFNetworking', '4.0.1'
#
#  # LOG
#  pod 'CocoaLumberjack'
#  pod 'AliyunOSSiOS'
#end

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

