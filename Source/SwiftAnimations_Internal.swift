//
//  Created by Miguel Angel Quinones
//  Copyright 2015 Miguel Angel Quinones. See LICENSE
//

import UIKit

internal class Animation {
    typealias AnimationAction = Void -> Void
    
    init(action: AnimationAction) {
        self.action = action
    }
    
    let action: AnimationAction
    var duration: NSTimeInterval = 1.0
    var options: UIViewAnimationOptions = .CurveEaseInOut
    
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