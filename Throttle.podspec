#
# Be sure to run `pod lib lint Throttle.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Throttle'
  s.version          = '1.0.0'
  s.summary          = 'A short description of Throttle.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/iStarEternal/Throttle'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Star' => '576681253@qq.com' }
  s.source           = { :git => 'https://github.com/iStarEternal/Throttle.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Throttle/Classes/Throttle.swift'
  
  s.subspec "Definition" do |ss|
    ss.source_files = 'Throttle/Classes/Throttle+Definition.swift'
  end
end
