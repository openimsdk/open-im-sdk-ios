Pod::Spec.new do |s|
  s.name = "OpenIM"

  s.version = '0.0.1'

  s.source = {
    :git => "https://github.com/OpenIMSDK/Open-IM-SDK-iOS.git",
    :tag => s.version,
    :submodules => true
  }

  s.license = 'Apache License 2.0'
  s.summary = 'OpenIM SDK for Swift.'
  s.homepage = 'https://github.com/OpenIMSDK/Open-IM-SDK-iOS'
  s.description = 'OpenIM SDK for Swift.'
  s.social_media_url = ''
  s.authors  = { 'Snow' => 'jangsky215@gmail.com' }
  s.documentation_url = 'https://github.com/OpenIMSDK/Open-IM-SDK-iOS'
  s.requires_arc = true
  
  s.swift_version = '5.3'

  # CocoaPods requires us to specify the root deployment targets
  # even though for us it is nonsense. Our root spec has no
  # sources.
  
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '3.0'
  s.tvos.deployment_target = '10.0'

  s.ios.vendored_frameworks = [
    'OpenIM/Source/OpenIMCore.framework',
  ]

  s.ios.vendored_library = [
    
  ]

  s.source_files = s.osx.source_files = [
    'OpenIM/Source/*.{h,m,swift}',
    'OpenIM/Source/*/*.{h,m,swift}',
    'OpenIM/Source/*/*/*.{h,m,swift}',
    'OpenIM/Source/*/*/*/*.{h,m,swift}',
  ]
  
  s.pod_target_xcconfig = {
    'ARCHS[sdk=iphoneos*]' => 'arm64',
  }
  
end
