#
# Be sure to run `pod lib lint MJCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MJCore'
  s.version          = '0.2.9'
  s.summary          = 'Personal core library build on RxSwift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/martinjanak/MJCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'martinjanak' => 'janak.martin@email.cz' }
  s.source           = { :git => 'https://github.com/martinjanak/MJCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }

  s.source_files = 'MJCore/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MJCore' => ['MJCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'SteviaLayout'
end
