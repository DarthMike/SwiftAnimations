//
//  ViewController.swift
//  Demo
//
//  Created by Miguel Angel Quinones on 05/02/2015.
//  Copyright (c) 2015 miqu. All rights reserved.
//

import UIKit
import SwiftAnimations

class ViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animate {
            self.testView.center.x += 100
            }.withDuration(5.0).thenAnimate {
                self.testView.center.x -= 200
            }.withDuration(2.0).withOptions(UIViewAnimationOptions.CurveEaseInOut).thenAnimate {
                self.testView.transform = CGAffineTransformMakeScale(1.5, 1.5)
            }.thenAnimate {
                self.testView.transform = CGAffineTransformRotate(self.testView.transform, CGFloat(M_PI))
            }.thenAnimate {
                self.testView.transform = CGAffineTransformIdentity
            }.start()
    }

    
    @IBOutlet private var testView: UIView!
}

