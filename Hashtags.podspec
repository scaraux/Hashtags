#
# Be sure to run `pod lib lint Hashtags.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Hashtags'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Hashtags.'
  s.swift_version    = '4.0'
  s.description      = "Display a list of hashtags dynamically." 
  s.homepage         = 'https://github.com/frenchfalcon/Hashtags'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gottingoscar@gmail.com' => 'gottingoscar@gmail.com' }
  s.source           = { :git => 'https//github.com/frenchfalcon/Hashtags.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Hashtags/Classes/**/*'
  
  s.resources = 'Hashtags/Assets/**/*.{png,storyboard}'
  s.resource_bundle = { 'Hashtags' => 'Hashtags/Assets/*.png' }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
