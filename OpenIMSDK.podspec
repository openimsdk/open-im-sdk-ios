#
# Be sure to run `pod lib lint OpenIMSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OpenIMSDK'
  s.version          = '2.3.1'
  s.summary          = 'Open-IM-SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  OpenIM：由前微信技术专家打造的基于 Go 实现的即时通讯（IM）项目，iOS版本IM SDK 可以轻松替代第三方IM云服务，打造具备聊天、社交功能的app。
                       DESC

  s.homepage         = 'https://github.com/OpenIMSDK/Open-IM-SDK-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'OpenIM' => 'https://github.com/OpenIMSDK/Open-IM-SDK-iOS' }
  s.source           = { :git => 'https://github.com/OpenIMSDK/Open-IM-SDK-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'    
  
  s.source_files = 'OpenIMSDK/OpenIMSDK.{h,m}'


  s.subspec 'Utils' do |ss|
    ss.source_files = 'OpenIMSDK/Utils/*.{h,m}'
  end

  s.subspec 'Callback' do |ss|
    ss.dependency 'OpenIMSDK/Utils'

    ss.source_files = 'OpenIMSDK/Callback/*.{h,m}'
  end

  s.subspec 'Model' do |ss|
    ss.dependency 'OpenIMSDK/Utils'

    ss.source_files = 'OpenIMSDK/Model/*.{h,m}'
  end

  s.subspec 'Interface' do |ss|
    ss.dependency 'OpenIMSDK/Model'
    ss.dependency 'OpenIMSDK/Callback'
    ss.dependency 'OpenIMSDK/Callbacker'

    ss.source_files = 'OpenIMSDK/Interface/*.{h,m}'
  end

  s.subspec 'Callbacker' do |ss|
    ss.dependency 'OpenIMSDK/Model'
    ss.dependency 'OpenIMSDK/Utils'

    ss.source_files = 'OpenIMSDK/Callbacker/*.{h,m}'
  end

  valid_archs = ['armv7s','arm64','x86_64']
  s.xcconfig = {
    'VALID_ARCHS' =>  valid_archs.join(' '),
  }

  s.pod_target_xcconfig = {
      'ARCHS[sdk=iphonesimulator*]' => '$(ARCHS_STANDARD_64_BIT)', 'DEFINES_MODULE' => 'YES'
  }


  s.static_framework = true

  s.dependency 'OpenIMSDKCore', '2.3.0'
  s.dependency 'MJExtension'
end
