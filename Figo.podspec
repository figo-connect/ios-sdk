
Pod::Spec.new do |s|

  s.name         = "Figo"
  s.version      = "2.0.3"
  s.summary      = "Wraps the figo Connect API endpoints in nicely typed Swift functions and types for your conveniece."
  s.description  = <<-DESC
  The figo Connect API allows you to easily access your bank account including transaction history and submitting payments.
  For a general introduction to figo and figo Connect please visit http://figo.io/.

  Albeit figo offers an interface to submit wire transfers, payment processing is not our focus. Our main interest is bringing peoples bank accounts into applications allowing a more seamless and rich user experience.

  API reference: http://docs.figo.io
                   DESC
  s.homepage     = "http://figo.io/"
  s.license      = "MIT"

  s.authors            = { "Christian König" => "koenig@hamburg.de" }
  s.social_media_url   = "https://twitter.com/figoapi"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.swift_version = '4.2'

  s.source        = { :git => "https://github.com/figo-connect/ios-sdk.git", :tag => "#{s.version}" }
  s.source_files  = "Source/**/*.swift"
  s.resources      = "*.cer"

end
