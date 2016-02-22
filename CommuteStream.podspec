#
# Be sure to run `pod lib lint CommuteStream.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CommuteStream"
  s.version          = "0.2.0"
  s.summary          = "A mobile transit advertising platform and SDK"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
		       CommuteStream is the best way to monetize mobile transit apps.
                       DESC

  s.homepage         = "https://github.com/CommuteStream/CommuteStreamSDK-iOS"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "David Rogers" => "davidorog@mac.com" }
  s.source           = { :git => "https://github.com/CommuteStream/CommuteStreamSDK-iOS.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'CommuteStream/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'MKNetworkKit', '~> 0.8'
  s.dependency 'GoogleMobileAds', '~> 7.6'
end
