
platform :ios, '9.0'
use_frameworks!

target 'demo_Chat' do


  # Pods for demo_Chat
pod 'Firebase/Core'
 pod 'Kingfisher', '~> 3.0'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Core'
pod 'Firebase/Storage'
pod "Pastel"
pod "Sharaku"
pod 'JSQMessagesViewController'

end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
