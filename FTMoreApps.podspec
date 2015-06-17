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
  s.summary          = "A short description of FTMoreApps."
  s.description      = <<-DESC
                       An optional longer description of FTMoreApps

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/<GITHUB_USERNAME>/FTMoreApps"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Felipe Tumonis" => "ftumonis@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/FTMoreApps.git", :tag => s.version.to_s }
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
