flutter_application_path = './flutter_module'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

# Uncomment the next line to define a global platform for your project
platform :ios, '13.5'

target 'shonichi' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for shonichi

  install_all_flutter_pods(flutter_application_path)
  
  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  # add pods for any other desired Firebase products
  # https://firebase.google.com/docs/ios/setup#available-pods

  target 'shonichiTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'shonichiUITests' do
    # Pods for testing
  end

end
