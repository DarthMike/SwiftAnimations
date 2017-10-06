//
//  Created by Miguel Angel Quinones
//  Copyright 2015 Miguel Angel Quinones. See LICENSE
//

import UIKit

// MARK: DSL entry point

/// DSL entry point to start a standard animation. See `springAnimate` for spring animations.
///
/// - parameter action: The animation block to execute. It is exactly the block that will be passed to `UIView.animateWithDuration` API
///
/// - returns: An instance of Animator. The Animator object will record all other animations that you chain. See it's public API.
public func animate(_ action: @escaping () -> Void) -> Animator {
    let firstAnimation = Animation(action: action)
    let list = AnimationList(first: firstAnimation)
    return Animator(animations: list)
}

/// DSL entry point to start a standard animation. See `animate` for standard animations.
///
/// - parameter action: The animation block to execute. It is exactly the block that will be passed to `UIView.animateWithDuration` API
///
/// - returns: An instance of Animator. The Animator object will record all other animations that you chain. See it's public API.
public func springAnimate(_ action: @escaping () -> Void) -> Animator {
    let firstAnimation = Animation(action: action)
    let list = AnimationList(first: firstAnimation)
    return Animator(animations: list)
}

// MARK: Follow up calls
/// This structure accumulates the animations you chain through it's API.
///
/// All methods return a new instance or self modified to reflect the change. This design
/// allows to chain method calls without having to save the struct in a var or let. So you rarely need to use
/// this struct directly, but rather use it as received from the DSL entry points.
///
/// See `animate` and `springAnimate`
public struct Animator {
    
    // MARK: Chaining animations calls
    
    /// Follow-up call to add another animation block.
    ///
    /// The animation will be run after the previous animation completes. It's equivalent to
    /// `UIView.animateWithDuration` and run another `UIView.animateWithDuration` as the completion block
    /// 
    /// - parameter action: The animation block to execute. It is exactly the block that will be passed to UIView.animateWithDuration API
    /// 
    /// - returns: An instance of Animator. Use it to chain follow-up calls, or configuration calls for current animation.
    @discardableResult
    public func thenAnimate(_ action: @escaping () -> Void) -> Animator {
        let newAnimation = Animation(action: action)
        _ = self.animations.append(newAnimation)
        return self
    }
    
    // MARK: Modification calls
    
    /// Follow-up call to modify duration of the last specified animation.
    /// 
    /// Calling this method after the DSL entry point, or `thenAnimate` will modify the duration of the
    /// last specified animation. If you don't call this then the default animation duration value will be used.
    /// 
    /// - parameter duration: The amount of time animation should run. Exactly same parameter as `UIView.animateWithDuration`
    /// 
    /// - returns: An instance of Animator. Use it to chain follow-up calls, or configuration calls for current animation.
    @discardableResult
    public func withDuration(_ duration: TimeInterval) -> Animator {
        self.animations.last.configuration.duration = duration
        return self
    }
    
    /// Follow-up call to modify delay of the last specified animation.
    ///
    /// Calling this method after the DSL entry point, or `thenAnimate` will modify the duration of the
    /// last specified animation. If you don't call this then the default animation delay value will be used.
    ///
    /// - parameter delay: The delay before animation runs. Exactly same parameter as `UIView.animateWithDuration`
    ///
    /// - returns: An instance of Animator. Use it to chain follow-up calls, or configuration calls for current animation.
    @discardableResult
    public func afterDelay(_ delay: TimeInterval) -> Animator {
        self.animations.last.configuration.delay = delay
        return self
    }
    
    /// Follow-up call to modify the options of the last specified animation.
    /// 
    /// Calling this method after the DSL entry point, or `thenAnimate` will modify the options of the
    /// last specified animation. If you don't call this then the default options will be used.
    /// 
    /// - parameter options: The options of the animation. Exactly same parameter as `UIView.animateWithDuration`
    /// 
    /// - returns: An instance of Animator. Use it to chain follow-up calls, or configuration calls for current animation.
    @discardableResult
    public func withOptions(_ options: UIViewAnimationOptions) -> Animator {
        self.animations.last.configuration.options = options
        return self
    }
    
    /// Follow-up call to modify the type of the last specified animation.
    /// 
    /// - parameter type: The type of animation. See `AnimationType` for values.
    /// 
    /// - returns: An instance of Animator. Use it to chain follow-up calls, or configuration calls for current animation.
    @discardableResult
    public func withType(_ type: AnimationType) -> Animator {
        self.animations.last.configuration.type = type
        return self
    }
    
    /// Follow-up call to modify the spring damping of the last spring animation.
    /// 
    /// Calling this method after the DSL entry point, or `thenAnimate` will modify the options of the
    /// last specified animation. If the last animation is not spring type, then this will be ignored. See `withType:`
    /// 
    /// - parameter damping: The spring damping value. Exactly same parameter as in `UIView.animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:`
    ///
    /// - returns: An instance of Animator. Use it to chain follow-up calls, or configuration calls for current animation.
    @discardableResult
    public func withSpringDamping(_ damping: CGFloat) -> Animator {
        self.animations.last.springConfiguration.damping = damping
        return self.withType(.spring)
    }
    
    /// Follow-up call to modify the spring velocity of the last spring animation.
    /// 
    /// Calling this method after the DSL entry point, or `thenAnimate` will modify the options of the
    /// last specified animation. If the last animation is not spring type, then this will be ignored. See `withType:'
    /// 
    /// - parameter velocity: The initial spring velocity value. Exactly same parameter as in `UIView.animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:`
    ///
    /// - returns: An instance of Animator. Use it to chain follow-up calls, or configuration calls for current animation.
    @discardableResult
    public func withInitialVelocity(_ velocity: CGFloat) -> Animator {
        self.animations.last.springConfiguration.initialVelocity = velocity
        return self.withType(.spring)
    }
    
    // MARK: Finish calls
    
    /// Last call of the DSL. Call this method to execute animations and get notified view completion block.
    /// 
    /// **Important** If you don't call this method, no animation will be executed.
    ///
    /// - parameter completion: The completion closure of nil if you are not interested in completion
    public func completion(_ completion: AnimationCompletion?) {
        let first = animations.first
        self.animateRecursive(first, completion: completion)
    }
    
    fileprivate func animateRecursive(_ animation: Animation, completion: AnimationCompletion? = nil) {
        let completion = { (completed: Bool) -> Void in
            if let next = animation.next {
                self.animateRecursive(next, completion: completion)
                return
            }
            
            if let completion = completion {
                completion(completed)
            }
        }
        
        switch animation.configuration.type {
        case .regular:
            UIView.animate(withDuration: animation.configuration.duration, delay: animation.configuration.delay, options: animation.configuration.options, animations: animation.action, completion: completion)
        case .spring:
            UIView.animate(withDuration: animation.configuration.duration, delay: animation.configuration.delay, usingSpringWithDamping: animation.springConfiguration.damping, initialSpringVelocity: animation.springConfiguration.damping, options: animation.configuration.options, animations: animation.action, completion: completion)
        }
    }
   
    /// The animation completion block
    public typealias AnimationCompletion = (Bool) -> Void
    fileprivate let animations: AnimationList
}

// MARK: Configuration values

/// This enumeration specifies the kind of animation.
/// By default animations are `Regular`
public enum AnimationType {
    /// Regular animations are interpolated animations with standard curves. Like `UIView.animateWithDuration:`
    case regular
    /// Spring animations are the exactly the ones specified by calling `UIView.animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:`
    case spring
}

/// Sets the default animation duration for all animations.
///
/// Instead of specifying animation values for every animation, you can set the default value using this function
/// and all animations will use it. You can instead tweak animations that are not following your default value.
///
/// - parameter duration: The default duration
public func setDefaultAnimationDuration(_ duration: TimeInterval) {
    globalDefaults = AnimationValues(duration: duration, delay:globalDefaults.delay, options: globalDefaults.options, type: globalDefaults.type)
}

/// Sets the default animation delay for all animations.
///
/// Instead of specifying animation values for every animation, you can set the default value using this function
/// and all animations will use it. You can instead tweak animations that are not following your default value.
///
/// - parameter delay: The default delay
public func setDefaultAnimationDelay(_ delay: TimeInterval) {
    globalDefaults = AnimationValues(duration: globalDefaults.duration, delay:delay, options: globalDefaults.options, type: globalDefaults.type)
}

/// Sets the default animation curve for all animations.
///
/// Instead of specifying animation values for every animation, you can set the default value using this function
/// and all animations will use it. You can instead tweak animations that are not following your default value.
///
/// - parameter curve: The curve to use for all animations
public func setDefaultAnimationCurve(_ curve: UIViewAnimationCurve) {
    globalDefaults = AnimationValues(duration: globalDefaults.duration, delay: globalDefaults.delay, options: UIViewAnimationOptions.fromCurve(curve), type: globalDefaults.type)
}

/// Sets the default animation type for all animations.
///
/// Instead of specifying animation values for every animation, you can set the default value using this function
/// and all animations will use it. You can instead tweak animations that are not following your default value.
///
/// - parameter type: The default animation type
public func setDefaultAnimationType(_ type: AnimationType) {
    globalDefaults = AnimationValues(duration: globalDefaults.duration, delay: globalDefaults.delay, options: globalDefaults.options, type: type)
}

/// Sets the default spring animation damping value for all animations.
///
/// Instead of specifying animation values for every animation, you can set the default value using this function
/// and all animations will use it. You can instead tweak animations that are not following your default value.
///
/// - parameter damping: The default spring damping value
public func setDefaultSpringDamping(_ damping: CGFloat) {
    globalSpringDefaults = SpringValues(damping: damping, initialVelocity: globalSpringDefaults.initialVelocity)
}

/// Sets the default spring animation velocity for all animations.
///
/// Instead of specifying animation values for every animation, you can set the default value using this function
/// and all animations will use it. You can instead tweak animations that are not following your default value.
///
/// - parameter velocity: The default velocity value
public func setDefaultInitialVelocity(_ velocity: CGFloat) {
    globalSpringDefaults = SpringValues(damping: globalSpringDefaults.damping, initialVelocity: velocity)
}
