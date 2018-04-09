platform :ios, '11.0'

target 'PocketCarbo' do
  use_frameworks!

  # Pods for PocketCarbo
  pod 'Firebase/Core'
  pod 'XLPagerTabStrip', '~> 8.0'
  pod 'SlideMenuControllerSwift'
  pod 'DropDown'
  pod 'RealmSwift'
  pod 'Toaster'
  pod 'Gecco'

  # Need for Realm
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
  end

  target 'PocketCarboTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PocketCarboUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
