Pod::Spec.new do |s|
  s.name             = "SwiftAnimations"
  s.version          = "1.4.0"
  s.summary          = "A small DSL to chain animations on top of UIKit"
  s.description      = <<-DESC
UIKit animations API is designed to be simple. It does it job very well for fire-and-forget animations. But there are some times where the application demands not so simple animations.
There are often times when two or three animations need to be chained to achieved desired visual effects. This DSL gives you an elegant and simple way to do just that.

##Features
* Chain simple animations with less and more concise code
* Sensible default values, so you don't repeat information across all animation blocks
* Opt in to configure whatever values you see fit on every animation, as opposed to declaring (and repeating) whole list of parameters for every one
* Default values can be configured for all animations across all application. Change only the values that are different for the specific animation
* Support for spring and standard animations
                       DESC
  s.homepage         = "https://github.com/DarthMike/SwiftAnimations"
  s.license          = 'MIT'
  s.author           = { "Miguel Angel Quinones Garcia" => "@miguelquinon" }
  s.source           = { :git => "https://github.com/DarthMike/SwiftAnimations.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.module_name = 'SwiftAnimations'
  s.source_files = 'Sources/*'
  s.swift_version = '4.2'

end
