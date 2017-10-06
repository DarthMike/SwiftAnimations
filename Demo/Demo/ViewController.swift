//
//  Created by Miguel Angel Quinones
//  Copyright 2015 Miguel Angel Quinones. See LICENSE
//

import UIKit
import SwiftAnimations

class ViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @IBAction func startAnimations() {
        let reset: Void->Void = {
            self.red.transform = CGAffineTransformIdentity
            self.green.transform = CGAffineTransformIdentity
            self.yellow.transform = CGAffineTransformIdentity
            self.blue.transform = CGAffineTransformIdentity
        }
        
        animate {
            self.red.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        }.thenAnimate {
            self.green.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI_2))
        }.afterDelay(1)
         .thenAnimate {
            self.blue.transform = CGAffineTransformMakeScale(1.5, 1)
        }.withOptions(.CurveLinear).withDuration(1).thenAnimate {
            self.yellow.transform = CGAffineTransformMakeScale(1, 1.5)
        }.withOptions(.CurveEaseIn)
         
         .thenAnimate {
            let scale = CGAffineTransformMakeScale(0.5, 0.5)
            self.red.transform = scale
            self.green.transform = scale
            self.blue.transform = scale
            self.yellow.transform = scale
        }.thenAnimate(reset).completion { _ in
            print("Completed!")
        }
    }
    
    @IBOutlet private var red: UIView!
    @IBOutlet private var green: UIView!
    @IBOutlet private var blue: UIView!
    @IBOutlet private var yellow: UIView!
}
