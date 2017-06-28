# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'The Wave' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Collection View custom scrolling
  pod 'UPCarouselFlowLayout'

  # Firebase
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/RemoteConfig'
  pod 'FirebaseUI'

  # Fabric
  pod 'Crashlytics'

  # SwiftKeychainWrapper
  pod 'SwiftKeychainWrapper'

  # JSQMessagesViewController
  pod 'JSQMessagesViewController'

  # OneSignal
  pod 'OneSignal', '~> 2.0'

  # Sentry
  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :subspecs => ['Core', 'KSCrash'], :tag => '3.1.2'

  target 'The Wave Tests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'OneSignalNotificationServiceExtension' do

use_frameworks!

  pod 'OneSignal', '~> 2.0'
end
