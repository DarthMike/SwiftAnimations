//
//  Created by Miguel Angel Quinones
//  Copyright 2015 Miguel Angel Quinones. See LICENSE
//

import UIKit
import SwiftAnimations

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @IBAction func startAnimations() {
        let reset: () -> Void = {
            self.red.transform = CGAffineTransform.identity
            self.green.transform = CGAffineTransform.identity
            self.yellow.transform = CGAffineTransform.identity
            self.blue.transform = CGAffineTransform.identity
        }
        
        animate {
            self.red.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }.thenAnimate {
            self.green.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi))
        }.afterDelay(1)
         .thenAnimate {
            self.blue.transform = CGAffineTransform(scaleX: 1.5, y: 1)
        }.withOptions(.curveLinear).withDuration(1).thenAnimate {
            self.yellow.transform = CGAffineTransform(scaleX: 1, y: 1.5)
        }.withOptions(.curveEaseIn)
         
         .thenAnimate {
            let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.red.transform = scale
            self.green.transform = scale
            self.blue.transform = scale
            self.yellow.transform = scale
        }.thenAnimate(reset).completion { _ in
            print("Completed!")
        }
    }
    
    @IBOutlet fileprivate var red: UIView!
    @IBOutlet fileprivate var green: UIView!
    @IBOutlet fileprivate var blue: UIView!
    @IBOutlet fileprivate var yellow: UIView!
}
