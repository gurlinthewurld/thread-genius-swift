Pod::Spec.new do |s|


  s.name         = "TGClient"
  s.version      = "0.0.1"
  s.summary      = "A Swift client for the Thread Genius API."

  s.homepage     = "http://threadgenius.co"
  s.license      = "MIT"

  s.author             = { "Theo Strauss" => "andrew@threadgenius.co" }

  # s.platform     = :ios
  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/theostrauss/TGClient.git", :tag => "#{s.version}" }


  s.source_files  = "TGClient", "TGClient/**/*.{h,m}"

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }




  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "Alamofire", "~> 4.4.0"

end
