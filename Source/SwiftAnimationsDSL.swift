//
//  Created by Miguel Angel Quinones
//  Copyright 2015 Miguel Angel Quinones. See LICENSE
//

import UIKit

// MARK: DSL entry point

public func animate(action:Void->Void) -> Animator {
    let firstAnimation = Animation(action: action)
    let list = AnimationList(first: firstAnimation)
    return Animator(animations: list)
}

public func springAnimate(action:Void->Void) -> Animator {
    let firstAnimation = Animation(action: action)
    let list = AnimationList(first: firstAnimation)
    return Animator(animations: list)
}

// MARK: Follow up calls

public struct Animator {
    
    // MARK: Chaining animations calls
    public func thenAnimate(action: Void->Void) -> Animator {
        let newAnimation = Animation(action: action)
        self.animations.append(newAnimation)
        return self
    }
    
    // MARK: Modification calls
    public func withDuration(duration: NSTimeInterval) -> Animator {
        self.animations.last.configuration.duration = duration
        return self
    }
    
    public func withOptions(options: UIViewAnimationOptions) -> Animator {
        self.animations.last.configuration.options = options
        return self
    }
    
    public func withType(type: AnimationType) -> Animator {
        self.animations.last.configuration.type = type
        return self
    }
    
    public func withSpringDamping(damping: CGFloat) -> Animator {
        self.animations.last.springConfiguration.damping = damping
        return self.withType(.Spring)
    }
    
    public func withInitialVelocity(velocity: CGFloat) -> Animator {
        self.animations.last.springConfiguration.initialVelocity = velocity
        return self.withType(.Spring)
    }
    
    // MARK: Finish calls
    public func completion(completion:AnimationCompletion?) {
        let first = animations.first
        self.animateRecursive(first, completion)
    }
    
    private func animateRecursive(animation: Animation, completion: AnimationCompletion? = nil) {
        let completion = { (completed: Bool)->(Void) in
            if let next = animation.next {
                self.animateRecursive(next, completion: completion)
                return;
            }
            
            if let completion = completion {
                completion(completed)
            }
        }
        
        switch animation.configuration.type {
        case .Regular:
            UIView.animateWithDuration(animation.configuration.duration, delay: 0.0, options: animation.configuration.options, animations: animation.action, completion: completion)
        case .Spring:
            UIView.animateWithDuration(animation.configuration.duration, delay: 0.0, usingSpringWithDamping: animation.springConfiguration.damping, initialSpringVelocity: animation.springConfiguration.damping, options: animation.configuration.options, animations: animation.action, completion: completion)
        }
    }
    
    public typealias AnimationCompletion = Bool->Void
    private let animations: AnimationList
}

// MARK: Configuration values

public enum AnimationType {
    case Regular
    case Spring
}

public func setDefaultAnimationDuration(duration: NSTimeInterval) {
    globalDefaults = AnimationValues(duration: duration, options: globalDefaults.options, type: globalDefaults.type)
}

public func setDefaultAnimationCurve(curve: UIViewAnimationCurve) {
    globalDefaults = AnimationValues(duration: globalDefaults.duration, options: UIViewAnimationOptions.fromCurve(curve), type: globalDefaults.type)
}

public func setDefaultAnimationType(type: AnimationType) {
    globalDefaults = AnimationValues(duration: globalDefaults.duration, options: globalDefaults.options, type: type)
}

public func setDefaultSpringDamping(damping: CGFloat) {
    globalSpringDefaults = SpringValues(damping: damping, initialVelocity: globalSpringDefaults.initialVelocity)
}

public func setDefaultInitialVelocity(velocity: CGFloat) {
    globalSpringDefaults = SpringValues(damping: globalSpringDefaults.damping, initialVelocity: velocity)
}
