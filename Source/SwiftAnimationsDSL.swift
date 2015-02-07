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
        self.animations.last.duration = duration
        return self
    }
    
    public func withOptions(options: UIViewAnimationOptions) -> Animator {
        self.animations.last.options = options
        return self
    }
    
    
    // MARK: Finish calls
    public func completion(completion:AnimationCompletion?) {
        let first = animations.first
        self.animateRecursive(first, completion)
    }
    
    private func animateRecursive(animation: Animation, completion: AnimationCompletion? = nil) {
        UIView.animateWithDuration(animation.duration, delay: 0.0, options: animation.options, animations: animation.action) {
            completed in
            
            if let next = animation.next {
                self.animateRecursive(next, completion: completion)
                return;
            }
            
            if let completion = completion {
                completion(completed)
            }
        }
    }
    
    public typealias AnimationCompletion = Bool->Void
    private let animations: AnimationList
}
