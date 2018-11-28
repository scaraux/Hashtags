#
# Be sure to run `pod lib lint Hashtags.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Hashtags'
  s.version          = '0.1.2'
  s.summary          = 'A swift library for displaying hashtags'
  s.swift_version    = '4.0'
  s.description      = "Display a list of hashtags dynamically." 
  s.homepage         = 'https://github.com/scaraux/Hashtags'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oscar Gotting' => 'https://twitter.com/scaraux' }
  s.source           = { :git => 'https://github.com/scaraux/Hashtags.git', :tag => s.version.to_s }


  s.ios.deployment_target = '9.0'

  s.source_files = 'Hashtags/Classes/**/*'
  
  s.resources = 'Hashtags/Assets/**/*.{png,storyboard}'
  s.resource_bundle = { 'Hashtags' => 'Hashtags/Assets/*.png' }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.dependency 'AlignedCollectionViewFlowLayout', '~> 1.1.2'
end
