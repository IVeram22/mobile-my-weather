# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'mobile-my-weather' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for mobile-weather
  pod 'SnapKit', '~> 5.0.0'
  pod 'SVProgressHUD', '~> 2.3'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end
