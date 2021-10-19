Pod::Spec.new do |s|
  s.name = "OpenIMUI"

  s.version = '0.0.2'

  s.source = {
    :git => "https://github.com/OpenIMSDK/Open-IM-SDK-iOS.git",
    :tag => s.version,
    :submodules => true
  }

  s.license = 'Apache License 2.0'
  s.summary = 'OpenIM SDK for Swift.'
  s.homepage = 'https://github.com/OpenIMSDK/Open-IM-SDK-iOS'
  s.description = 'OpenIMUI SDK for Swift.'
  s.social_media_url = ''
  s.authors  = { 'Snow' => 'jangsky215@gmail.com' }
  s.documentation_url = 'https://github.com/OpenIMSDK/Open-IM-SDK-iOS'
  s.requires_arc = true
  
  s.swift_version = '5.3'

  # CocoaPods requires us to specify the root deployment targets
  # even though for us it is nonsense. Our root spec has no
  # sources.
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = s.osx.source_files = [
    'OpenIMUI/Source/*.{h,m,swift}',
    'OpenIMUI/Source/*/*.{h,m,swift}',
    'OpenIMUI/Source/*/*/*.{h,m,swift}',
    'OpenIMUI/Source/*/*/*/*.{h,m,swift}',
  ]
  
  s.resource_bundles = {
    'OpenIMUI' => [
      'OpenIMUI/*.xcassets',
      'OpenIMUI/*.lproj',
    ],
  }
  
  s.dependency 'Kingfisher', '>= 6.0'
  s.dependency 'OpenIM', '>= 0.0.1'
  s.ios.deployment_target = '11.0'
end
