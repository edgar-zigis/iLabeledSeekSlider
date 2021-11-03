Pod::Spec.new do |spec|
  spec.name         = "iLabeledSeekSlider"
  spec.version      = "1.0.2"
  spec.summary      = "Custom & highly configurable seek slider with sliding intervals, disabled state and every possible setting to tackle!"

  spec.homepage     = "https://github.com/edgar-zigis/iLabeledSeekSlider"
  spec.screenshots  = "https://raw.githubusercontent.com/edgar-zigis/LabeledSeekSlider/master/sample-slide.gif"

  spec.license      = { :type => 'MIT', :file => './LICENSE' }

  spec.author       = "Edgar Žigis"

  spec.platform     = :ios
  spec.ios.deployment_target = '9.0'
  spec.swift_version = '5.2'
  
  spec.source       = { :git => "https://github.com/edgar-zigis/iLabeledSeekSlider.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/iLabeledSeekSlider/**/*.{swift}"
end
