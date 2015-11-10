#
#  Be sure to run `pod spec lint QFToolBar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "LXToolBar"
  s.version      = "0.1"
  s.summary      = "定制的工具条，类似UITabBar，基于AutoLayout支持横竖屏切换"
  s.homepage     = "https://github.com/xx-li/LXToolBar"
  s.license      = 'MIT'

  s.author       = { "xx-li" => "13348782277@163.com" }
 
  s.platform     = :ios, '6.0'

  s.source       = { :git => "https://github.com/xx-li/LXToolBar.git", :tag => "0.1" }

  s.source_files  = 'LXToolBar/*', 'LXToolBar/**/*.{h,m}'
  s.exclude_files = 'LXToolBarDemo'

  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "LXLayoutButton", "~> 0.0.1"

end
