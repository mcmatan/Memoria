

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'Memoria' do
pod 'Swinject', '~> 2.0.0-beta.2'
pod 'SnapKit', '~> 3.0.1'
pod 'SwiftDate', '~> 4.0'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'EstimoteSDK', :git => 'https://github.com/Estimote/iOS-SDK.git', :commit => '66c9cf13467bc0f61fcf197116dadfe22e1cd10d'
    pod 'RxSwift',    '~> 3.0'
    pod 'RxCocoa',    '~> 3.0'
    pod 'Kingfisher', '~> 3.2'
pod 'EmitterKit', '~> 5.0'
pod "ATHMultiSelectionSegmentedControl"
pod 'DZNEmptyDataSet'
pod "TouchVisualizer", '~>2.0.1'




pod 'AEConsole', '~> 0.3'




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