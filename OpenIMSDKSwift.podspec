Pod::Spec.new do |s|
  s.name             = 'OpenIMSDKSwift'
  s.version          = '4.0.0-alpha.1'
  s.summary          = 'Swift-first OpenIM SDK for iOS'
  s.description      = <<-DESC
    Swift-first OpenIM SDK. The Swift API is backed by the OpenIMCore XCFramework.
  DESC
  s.homepage         = 'https://github.com/OpenIMSDK/Open-IM-SDK-iOS'
  s.license          = { :type => 'AGPL-3.0', :file => 'LICENSE' }
  s.author           = { 'OpenIM' => 'https://github.com/OpenIMSDK/Open-IM-SDK-iOS' }
  s.source           = { :git => 'https://github.com/OpenIMSDK/Open-IM-SDK-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.9'
  # Keep the import/module name identical to the SwiftPM product.
  s.module_name = 'OpenIMSDK'
  s.source_files = 'Sources/OpenIMSDK/**/*.swift'
  s.dependency 'OpenIMSDKCore', '3.8.3-hotfix.14'
  s.static_framework = true
end
