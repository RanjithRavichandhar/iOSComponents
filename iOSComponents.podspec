#
# Be sure to run `pod lib lint iOSComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iOSComponents'
  s.version          = '0.1.6'
  s.summary          = 'iOSComponents is created by M2P build iOS Applications and Frameworks.'
  s.license = 'MIT'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = 'iOSComponents is created by M2P. iOSComponents provides lightweight UI Fields that enchance project performance.'
  
  s.homepage         = 'https://github.com/RanjithRavichandhar/iOSComponents'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RanjithRavichandhar' => 'ranjith@m2p.in' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
  # platform
  s.platform = :ios
  s.swift_version = '5.0'
  s.ios.deployment_target = '11.0'
  
  # source
  s.source_files = 'iOSComponents/Classes/**/*'
  s.source           = { :git => 'https://github.com/RanjithRavichandhar/iOSComponents.git', :tag => s.version.to_s }
  s.resource_bundles = {
    'Resources' => ['iOSComponents/Assets/*{.png,.json,.xib,.wav}']
  }
  
  # build settings
  s.frameworks = 'Foundation', 'UIKit'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
