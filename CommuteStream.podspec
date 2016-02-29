Pod::Spec.new do |s|
  s.name         = "CommuteStream"
  s.version      = "0.3.0"
  s.summary      = "CommuteStream iOS SDK"
  s.description  = <<-DESC
                   Software development kit for the best way to monetize transit apps
                   DESC
  s.homepage     = "https://commutestream.com"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author       = { "CommuteStream" => "contact@commutestream.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/CommuteStream/CommuteStreamSDK-iOS.git", :tag => "0.3.0" }
  s.source_files  = "CommuteStream", "CommuteStream/**/*.{h,m}"
  s.public_header_files = "CommuteStream/*.h"
  s.ios.vendored_frameworks = "Frameworks/GoogleMobileAds.framework"
  s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/CommuteStream/Frameworks"' }
  s.requires_arc = true
  s.dependency "AFNetworking", "~> 3.0"
  #TODO removed the vendored framework s.dependency "Google-Mobile-Ads-SDK", "~> 7.7"
end
