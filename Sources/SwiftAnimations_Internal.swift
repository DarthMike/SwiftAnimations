//
//  Created by Miguel Angel Quinones
//  Copyright 2015 Miguel Angel Quinones. See LICENSE
//

import UIKit

// MARK: Curve->Options
extension UIViewAnimationOptions {
    static func fromCurve(_ curve: UIViewAnimationCurve) -> UIViewAnimationOptions {
        switch curve {
        case .easeIn:
            return .curveEaseIn
        case .easeInOut:
            return UIViewAnimationOptions()
        case .easeOut:
            return .curveEaseOut
        case .linear:
            return .curveLinear
        }
    }
}

// MARK: Defaults

internal struct AnimationValues {
    var duration: TimeInterval  = 0.4
    var delay: TimeInterval = 0
    var options: UIViewAnimationOptions = .curveEaseOut
    var type: AnimationType = .regular
}

internal struct SpringValues {
    var damping: CGFloat = 0.4
    var initialVelocity: CGFloat = 0.2
}

var globalDefaults = AnimationValues()
var globalSpringDefaults = SpringValues()

// MARK: Internal animation data structures
internal class Animation {
    typealias AnimationAction = () -> Void
    
    init(action: @escaping AnimationAction) {
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
        var node = first
        repeat {
            if let nextNode = node.next {
                node = nextNode
            }
        } while node.next != nil
        
        return node
    }
    
    func append(_ animation: Animation) -> AnimationList {
        self.last.next = animation
        return AnimationList(first: first)
    }
}
