platform :ios, '11'
use_frameworks!
use_modular_headers!

workspace 'EEChat.xcworkspace'

def sharedUILibs()
  pod 'Kingfisher', '~> 6.0'
end

def sharedLibs()
  pod 'GRDB.swift', '~> 5.7.3'
  pod 'RxSwift', '~> 6.1.0'
  pod 'Alamofire', '~> 5.2'
end

target 'EEChat' do
  project 'EEChat.xcodeproj'
  
  sharedLibs()
  sharedUILibs()
  
  pod 'OpenIM', :path => '.'
  pod 'OpenIMUI', :path => '.'
  
  pod 'MBProgressHUD', '~> 1.2.0'
  
  pod 'RxCocoa', '~> 6.1.0'
  pod 'RxGesture', '~> 4.0.2'
  pod 'RxDataSources', '~> 5.0.0'

  pod 'SnapKit', '~> 5.0.0'
  
  pod 'IQKeyboardManagerSwift', '~> 6.5.0'
  
#  pod 'MBProgressHUD', :git => 'https://github.com/jdg/MBProgressHUD.git', :commit => '8df5e8ca98a89473385cd66543435de114f166bd'

  pod 'CryptoSwift', '~> 1.4.0'
  pod 'web3swift', git: "https://github.com/BeeModule/web3swift.git", :commit => '7cc049ffb7409ccbf15dde7a7021527bd961f6cc'
  
  pod 'Toast', '~> 4.0.0'
  
  pod 'TPNS-iOS', '~> 1.3.4.1'
  pod 'QCloudCOSXML/Slim', '~> 5.8.4'
  
  pod 'TZImagePickerController', '~> 3.6.0'
  #pod 'TZImagePreviewController', '~> 0.5.0'
  
  pod 'YYImage', :git => 'https://github.com/QiuYeHong90/YYImage.git'
  pod 'YBImageBrowser', '~> 3.0.9'
  pod 'YBImageBrowser/Video', '~> 3.0.9'
  
  pod 'QMUIKit', '~> 4.2.3'
  
  pod 'Bugly', '~> 2.5.90'
  pod 'Reveal-SDK', '~> 21', :configurations => ['Debug']
  pod 'PgyUpdate', :configurations => ['Debug', 'Beta']
end

#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    if ['OpenIM'].include? target.name
#      target.build_configurations.each do |config|
#        if config.name != 'Debug'
#          config.build_settings['ARCHS[sdk=iphoneos*]'] = 'arm64'
#        end
#      end
#    end
#  end
#end


