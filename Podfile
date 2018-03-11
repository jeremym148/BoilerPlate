platform :ios, '10.0'
source 'https://github.com/forcedotcom/SalesforceMobileSDK-iOS-Specs.git' # needs to be first
source 'https://github.com/CocoaPods/Specs.git'

target 'Balink iOS boilerplate' do
  use_frameworks!

pod 'SalesforceSDKCore' 
pod 'ReSwift'
pod 'MGSwipeTableCell'
pod 'IQKeyboardManagerSwift'
pod 'Kingfisher'
pod 'Fabric'
pod 'Crashlytics'
pod 'GSImageViewerController'

pre_install do |installer|
    def installer.verify_no_static_framework_transitive_dependencies; end
end

end
