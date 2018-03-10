#
# Be sure to run `pod lib lint MiniFlake.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'MiniFlake'
  s.version          = '0.0.5'
  s.summary          = 'Generates time-ordered identifiers as positive 64-bit integers without synchronization.'

  s.description      = <<-DESC
    A Swift micro-framework for generating compact identifiers that are time ordered without the need for synchronization. Unlike UUID-based methods, the identifiers would only be 63-bits long — hence fit as a positive number in a 64-bit integer. These identifiers are also roughly time-ordered, hence can be used as a sorting attribute to get the corresponding data objects sorted by time as well.
    Inspired from Twitter Snowflake identifier-creation algorithm.
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
