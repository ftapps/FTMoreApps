#
# Be sure to run `pod lib lint FTMoreApps.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FTMoreApps"
  s.version          = "0.1.0"
  s.summary          = "FTMoreApps presents a view controller similar to the App Store to show your apps."
  s.description      = <<-DESC
                       FTMoreApps presents a view controller similar to the App Store to show your apps. You can setup it with your developer ID and show all your apps ou define an array of app ids to present."

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/ftapps/FTMoreApps"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Felipe Tumonis" => "ftumonis@gmail.com" }
  s.source           = { :git => "https://github.com/ftapps/FTMoreApps.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'FTMoreApps' => ['*.lproj']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'SDWebImage', '~>3.7'
end
