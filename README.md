# SwiftAnimations

SwiftAnimations is a small DSL to chain of animations on top of UIKit.

#Example

Turn complex sequences of animations into simple cascade and easy to read code:

```swift
animate {
  self.red.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
}.thenAnimate {
  self.green.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI_2))
}.thenAnimate {
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
  println("Completed!")
}
```

#Features
- Sensible default values, so you don't repeat information across all animation blocks
- Opt in to configure whatever values you see fit on every animation, as opposed to declaring whole list of parameters for every one
- Super-readable code

#Roadmap
This is 2 hour project, but since I've been toying with this idea, I see lots of potential to expand the library to offer more features:

- Predefined animations:

```swift
animate(flip(self.avatarView))
.thenAnimate(bounce(self.button)).start()
```

- Unifying constants and animation defaults across application
- Support for spring as well as standard animations
- Suggestions and pull requests welcome :)

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

#Author

[Miguel Angel Quiñones](http://miqu.me) / [@miguelquinon](http://twitter.com/miguelquinon)

#Inspiration

This idea took off from working in my current project using Swift, and after seeing [Spring](https://github.com/MengTo/Spring)
