//
//  Created by Miguel Angel Quinones
//  Copyright 2015 Miguel Angel Quinones. See LICENSE.
//

import UIKit

public func animate(action:Void->Void) -> Animator {
    let firstAnimation = Animation(action: action)
    let list = AnimationList(first: firstAnimation)
    return Animator(animations: list)
}

public struct Animator {
    public func thenAnimate(action: Void->Void) -> Animator {
        let newAnimation = Animation(action: action)
        self.animations.append(newAnimation)
        return self
    }
    
    public func start() {
        let first = animations.first
        self.animateRecursive(first)
    }
    
    public func withDuration(duration: NSTimeInterval) -> Animator {
        self.animations.last.duration = duration
        return self
    }
    
    public func withOptions(options: UIViewAnimationOptions) -> Animator {
        self.animations.last.options = options
        return self
    }
    
    private func animateRecursive(animation: Animation) {
        UIView.animateWithDuration(animation.duration, delay: 0.0, options: animation.options, animations: animation.action) {
            completed in
            if let next = animation.next {
                self.animateRecursive(next)
            }
        }
    }
    
    private let animations: AnimationList
}
