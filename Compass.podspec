Pod::Spec.new do |s|
  s.name         = "Compass"
  s.version      = "0.0.1"
  s.summary      = "Sometimes a map just isn't enough"

  s.description  = <<-DESC
                   Useful things when working with Apple's MapKit, and maybe others too.
                   DESC

  s.homepage     = "https://github.com/fcanas/Compass"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "Fabian Canas" => "fcanas@gmail.com" }
  s.social_media_url   = "http://twitter.com/fcanas"
  s.platform     = :ios, "8.0"
  # mac os coming eventually
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  s.source       = { :git => "https://github.com/fcanas/Compass.git", :commit => "04ea7a4e93d9f49635bb73f3c6b0350ae8506a1e" }
  s.source_files  = "Compass", "Compass/**/*.swift"
  # s.exclude_files = "Classes/Exclude"

  s.framework  = "MapKit"
end
