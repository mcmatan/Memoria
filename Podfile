

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'Memoria' do
pod 'Swinject', '~> 2.0.0-beta.2'
pod 'SnapKit', '~> 3.0.1'
pod 'SwiftDate', '~> 4.0'
pod 'KontaktSDK', '~> 1.1'
pod 'EstimoteSDK', '~> 4.9'

# pod 'KontaktSDK', '~> 1.0'

end

target 'MemoriaTests' do

end

target 'MemoriaUITests' do

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end