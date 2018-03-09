#
# Be sure to run `pod lib lint MiniFlake.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'MiniFlake'
  s.version          = '0.0.3'
  s.summary          = 'Generates k-ordered identifiers as positive 64-bit integers without synchronization.'

  s.description      = <<-DESC
    A Swift micro-framework for generating compact identifiers that are time ordered in distributed systems without the need for synchronization.
                       DESC

  s.homepage         = 'https://github.com/adib/MiniFlake.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE.markdown' }
  s.authors          = { 'Sasmito Adibowo' => 'adib@basil-salad.com' }
  s.source           = { :git => 'https://github.com/adib/MiniFlake.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/cutecoder'
  s.documentation_url = 'https://github.com/adib/MiniFlake/blob/master/README.markdown'

  s.swift_version = '4.0'
  s.osx.deployment_target = "10.12"
  s.ios.deployment_target = "10.3"
  s.tvos.deployment_target = "10.2"
  s.watchos.deployment_target = "3.2"

  s.source_files = 'MiniFlake/Classes/**/*'
  s.weak_framework = 'CoreData'
end
