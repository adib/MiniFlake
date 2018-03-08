#
# Be sure to run `pod lib lint MiniFlake.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MiniFlake'
  s.version          = '0.0.1'
  s.summary          = 'Generates k-ordered identifiers as positive 64-bit integers without synchronization.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    A Swift micro-framework for generating compact identifiers that are time ordered in distributed systems without the need for synchronization.
                       DESC

  s.homepage         = 'https://github.com/adib/MiniFlake.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE.markdown' }
  s.authors          = { 'Sasmito Adibowo' => 'adib@basil-salad.com' }
  s.source           = { :git => 'https://github.com/adib/MiniFlake.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cutecoder'

  s.swift_version = '4.0'
  s.osx.deployment_target = "10.12"
  s.ios.deployment_target = "10.3"
  s.tvos.deployment_target = "10.2"
  s.watchos.deployment_target = "3.2"

  s.source_files = 'MiniFlake/Classes/**/*'

  # s.resource_bundles = {
  #   'MiniFlake' => ['MiniFlake/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'Cocoa'
  s.weak_framework = 'CoreData'
  # s.dependency 'AFNetworking', '~> 2.3'
end
