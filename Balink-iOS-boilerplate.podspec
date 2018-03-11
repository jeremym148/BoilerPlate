Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "Balink-iOS-boilerplate"
s.summary = "Balink-iOS-boilerplate lets a user select an ice cream flavor."
s.requires_arc = true

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Balink" => "jeremy.m@balink.net" }

# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/jeremym148/BoilerPlate"


# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/jeremym148/BoilerPlate.git", :tag => "master"}


# 7
s.framework = "UIKit"
s.dependency 'Alamofire', '~> 2.0'
s.dependency 'MBProgressHUD', '~> 0.9.0'
s.dependency 'SalesforceSDKCore'
s.dependency 'ReSwift'
s.dependency 'MGSwipeTableCell'
s.dependency 'IQKeyboardManagerSwift'
s.dependency 'Kingfisher'
s.dependency 'Fabric'
s.dependency 'Crashlytics'
s.dependency 'GSImageViewerController'

# 8
s.source_files = "Balink-iOS-boilerplate/**/*.{swift}"

# 9
s.resources = "Balink-iOS-boilerplate/**/*.{png,jpeg,jpg,storyboard,xib}"
end
