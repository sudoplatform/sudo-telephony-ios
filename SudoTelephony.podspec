Pod::Spec.new do |spec|
  spec.name                  = 'SudoTelephony'
  spec.version               = '3.1.1'
  spec.author                = { 'Sudo Platform Engineering' => 'sudoplatform-engineering@anonyome.com' }
  spec.homepage              = 'https://sudoplatform.com'
  spec.summary               = 'Telephony SDK for the Sudo Platform by Anonyome Labs.'
  spec.license               = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  spec.source                = { :git => 'https://github.com/sudoplatform/sudo-telephony-ios.git', :tag => "v#{spec.version}" }
  spec.source_files          = "SudoTelephony/**/*.swift"
  spec.ios.deployment_target = '11.0'
  spec.requires_arc          = true
  spec.swift_version         = '5.0'

  spec.dependency 'SudoUser', '~> 7.8'
  spec.dependency 'SudoProfiles', '~> 5.4'
  spec.dependency 'SudoApiClient', '~> 1.3'
  spec.dependency 'SudoOperations', '~> 2.0'

  spec.dependency 'TwilioVoice', '~> 5.3'
end
