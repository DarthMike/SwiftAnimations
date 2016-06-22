[![Build Status](https://travis-ci.org/DarthMike/SwiftAnimations.svg?branch=master)](https://travis-ci.org/DarthMike/SwiftAnimations)
[![Pod version](https://img.shields.io/cocoapods/v/SnapKit.svg)](https://cocoapods.org/pods/SwiftAnimations)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

[![Pod Platform](https://img.shields.io/cocoapods/p/SwiftAnimations.svg?style=flat)](https://cocoapods.org/pods/SwiftAnimations)
[![Pod License](https://img.shields.io/cocoapods/l/SwiftAnimations.svg?style=flat)](https://github.com/SwiftAnimations/blob/master/LICENSE.md)


[![codebeat badge](https://codebeat.co/badges/bbdd604a-0264-4c2f-8b8b-eb5d22ba4b60)](https://codebeat.co/projects/github-com-darthmike-swiftanimations)
[![cocoapods-doc](https://img.shields.io/cocoapods/metrics/doc-percent/SwiftAnimations.svg)](http://cocoadocs.org/docsets/SwiftAnimations)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/darthmike/swiftanimations)](http://clayallsopp.github.io/readme-score?url=https://github.com/darthmike/swiftanimations)

# SwiftAnimations

`SwiftAnimations` is a small DSL to chain of animations on top of UIKit, unify animation parameters across all application and simplify even more your animation code.

#Features
- Chain simple animations with less and more concise code
- Sensible default values, so you don't repeat information across all animation blocks
- Opt in to configure whatever values you see fit on every animation, as opposed to declaring (and repeating) whole list of parameters for every one
- Default values can be configured for all animations across all application. Change only the values that are different for the specific animation
- Support for spring and standard animations

#Chaining animations

Turn complex sequences of animations into simple cascade and easy to read code:

```swift
// Start with a call to 'animate'
animate {
  self.red.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
}.thenAnimate {   // Chain animations, to be executed in order
  self.green.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI_2))
}.afterDelay(1)
 .thenAnimate {
  self.blue.transform = CGAffineTransformMakeScale(1.5, 1)
}.withOptions(.CurveEaseOut).thenAnimate {
  self.yellow.transform = CGAffineTransformMakeScale(1, 1.5)
}.withOptions(.CurveEaseOut).thenAnimate {
  let scale = CGAffineTransformMakeScale(0.5, 0.5)
  self.red.transform = scale
  self.green.transform = scale
  self.blue.transform = scale
  self.yellow.transform = scale
}.completion { completed in
 // Completion of all animations
  println("Completed!")
}
```

#Unified animation values and default values
`SwiftAnimations` configures all animations with default values for duration, curve, and spring damping and velocity. You can change this globally or per-animation.
```swift
// All animations in my app have a baseline of 0.35. I rarely change this
setDefaultAnimationDuration(0.35)
// All animations in my app by default EaseIn EaseOut.
setDefaultAnimationCurve(.EaseInOut)
```
Also by default animations are 'standard', not spring animations. You can make all animations change the system call they use by switching a simple configuration value:
```swift
// I want unified look across application, and I will be using spring animations everywhere unless otherwise specified
setDefaultAnimationType(.Spring)
// Moreover, tedious repetition removed by specifying a default value for damping and velocity
setDefaultSpringDamping(0.1)
setDefaultInitialVelocity(0.3)
```

If you don't specify default values, the library will use the default ones.

#Per-animation parameters

You can also change specific values per-animation:

```swift
animate {
  // Animation 1
}.withOptions(.CurveEaseOut).withDuration(0.5).thenAnimate {   // Modify how 'previous' animation is performed
  // Animation 2
}.withDuration(0.1).withType(.Spring).thenAnimate {
  // Animation 3
}.withType(.Regular)
 .afterDelay(0.2)

```

#Roadmap
Later I will be adding redefined animations. And maybe a way to configure those as well across all application code.

```swift
animate(flip(self.avatarView))
.thenAnimate(bounce(self.button)).start()
```

**Suggestions and pull requests welcome :)**

#Why?

UIKit animations API is designed to be simple. It does it job very well for fire-and-forget animations. But there are some times where
the application demands not so simple animations.

There are often times when two or three animations need to be chained to achieved desired visual effects. Generally this can be *easily* done
by nesting UIKit.animateWithDuration(...) calls, like so:

```swift
UIView.animateWithDuration(0.3, animations: {
  //AnimationA
}, completion: {
  UIView.animateWithDuration(0.3, animations: {
    //AnimationB
  }, completion: {
    UIView.animateWithDuration(0.3, animations: {
      //AnimationC
    }, completion: {
      UIView.animateWithDuration(0.3, animations: {
        //AnimationD
      }, completion: {
        //Usual cleanup
      })
    })
  })
})
```

Imagine how this thing looks in Objective-C.

There is a big problem with this approach, and it is readability. Swift can make it a bit less painful if you abstract the animations into inner functions
of the current function, but I would say that it is very ugly code. And I believe that animation and UI code should be crystal clear, so you don't have to
run everything to see what will move around, and where.

See more [in the article I wrote](http://www.miqu.me/blog/2015/02/05/swift-animations/)

#Installation

##CocoaPods
Add the pod to your `Podfile`. Being a Swift-only library, it is required to be linked as a framework (dynamic library).
```Ruby
use_frameworks!
pod 'SwiftAnimations'
```

##Carthage
Add the repository to your Cartfile.
```Bash
github "DarthMike/SwiftAnimations"
```

Then drag and drop the produced SwiftAnimations.framework from Carthage/build

##Manual
Just drop into your project the files under Source directory.

#Author

[Miguel Angel Quiñones](http://miqu.me) / [@miguelquinon](http://twitter.com/miguelquinon)

#Inspiration

This idea took off from working in my current project using Swift, and after seeing [Spring](https://github.com/MengTo/Spring)
