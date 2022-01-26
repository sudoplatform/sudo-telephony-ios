# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'
use_frameworks!

use_modular_headers!
inhibit_all_warnings!

source 'https://cdn.cocoapods.org/'

target 'SudoTelephony' do

  # Pods for SudoTelephony
  podspec :name => 'SudoTelephony'

  target 'SudoTelephonyTests' do
    inherit! :search_paths
    podspec :name => 'SudoTelephony'
  end

  target 'SudoTelephonyIntegrationTests' do
    inherit! :search_paths
    podspec :name => 'SudoTelephony'
    pod 'SudoEntitlements'
  end

end
