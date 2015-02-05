//
//  Created by Miguel Angel Quinones
//  Copyright 2015 Miguel Angel Quinones. See LICENSE
//

import UIKit


internal struct AnimationDefaults {
    static let defaultDuration: NSTimeInterval  = 0.4
    static let defaultCurve: UIViewAnimationOptions = .CurveEaseOut
}

internal class Animation {
    typealias AnimationAction = Void -> Void
    
    init(action: AnimationAction) {
        self.action = action
    }
    
    let action: AnimationAction
    var duration: NSTimeInterval = AnimationDefaults.defaultDuration
    var options: UIViewAnimationOptions = AnimationDefaults.defaultCurve
    
    var next: Animation?
}

internal struct AnimationList {
    let first: Animation
    
    var last: Animation {
        get {
            var node = first
            do {
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