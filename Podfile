source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Artsy/Specs.git'

platform :osx, '10.14'
inhibit_all_warnings!
use_frameworks!

target 'YToke' do
  pod "XCDYouTubeKit", "~> 2.14.1"
  pod 'SwiftLint'
  pod 'SDWebImage', '~> 5.0'
end

target 'YTokeTests' do
    pod "XCDYouTubeKit", "~> 2.14.1"
    pod 'SDWebImage', '~> 5.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
  end
end
