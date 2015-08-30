//
//  Created by Miguel Angel Quinones
//  Copyright 2015 Miguel Angel Quinones. See LICENSE
//

import UIKit

// MARK: Curve->Options
extension UIViewAnimationOptions {
    static func fromCurve(curve: UIViewAnimationCurve) -> UIViewAnimationOptions {
        switch curve {
        case .EaseIn:
            return .CurveEaseIn
        case .EaseInOut:
            return .CurveEaseInOut
        case .EaseOut:
            return .CurveEaseOut
        case .Linear:
            return .CurveLinear
        }
    }
}

// MARK: Defaults

internal struct AnimationValues  {
    var duration: NSTimeInterval  = 0.4
    var options: UIViewAnimationOptions = .CurveEaseOut
    var type: AnimationType = .Regular
}

internal struct SpringValues  {
    var damping: CGFloat = 0.4
    var initialVelocity: CGFloat = 0.2
}

var globalDefaults = AnimationValues()
var globalSpringDefaults = SpringValues()

// MARK: Internal animation data structures
internal class Animation {
    typealias AnimationAction = Void -> Void
    
    init(action: AnimationAction) {
        self.action = action
        self.configuration = globalDefaults
        self.springConfiguration = globalSpringDefaults
    }
    
    let action: AnimationAction
    var configuration: AnimationValues
    var springConfiguration: SpringValues
    
    var next: Animation?
}

internal struct AnimationList {
    let first: Animation
    
    var last: Animation {
        get {
            var node = first
            repeat {
                if let nextNode = node.next  {
                    node = nextNode
                }
            } while node.next != nil
            
            return node
        }
    }
    
    func append(animation: Animation) -> AnimationList {
        self.last.next = animation
        return AnimationList(first: first)
    }
}