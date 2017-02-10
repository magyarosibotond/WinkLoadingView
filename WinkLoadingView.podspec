Pod::Spec.new do |s|
  s.name             = 'WinkLoadingView'
  s.version          = '0.1.0'
  s.summary          = 'WinkLoadingView is a smiley loading indicator.'

  s.description      = <<-DESC
WinkLoadingView is a loading indicator inspired by Windows® Hello.
                       DESC

  s.homepage         = 'https://github.com/magyarosibotond/WinkLoadingView'
  s.screenshots      = 'https://github.com/magyarosibotond/WinkLoadingView/screenshots/screenshots1.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'magyarosibotond' => 'mboti@halcyonmobile.com' }
  s.source           = { :git => 'https://github.com/magyarosibotond/WinkLoadingView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MagyarosiBotond'

  s.ios.deployment_target = '9.0'

  s.source_files = 'WinkLoadingView/Classes/**/*'
end
