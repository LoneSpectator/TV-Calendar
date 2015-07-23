//
//  ViewController.swift
//  TV-Calendar
//
//  Created by GaoMing on 15/4/8.
//  Copyright (c) 2015年 ifLab. All rights reserved.
//

import Foundation

class ViewController: MSRSegmentedViewController {
    var firstAppear = true
    override class var positionOfSegmentedControl: MSRSegmentedControlPosition {
        return .Top
    }
    override func loadView() {
        super.loadView()
        segmentedControl.indicator = MSRSegmentedControlUnderlineIndicator()
        segmentedControl.indicator.tintColor = UIColor.blueColor()
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppear {
            let createViewControllerWithColor: (UIColor) -> UIViewController = {
                color in
                let vc = UIViewController()
                vc.view.backgroundColor = color
                return vc
            }
            setViewControllers([
                createViewControllerWithColor(UIColor.msr_randomColor(opaque: true)),
                createViewControllerWithColor(UIColor.msr_randomColor(opaque: true)),
                createViewControllerWithColor(UIColor.msr_randomColor(opaque: true)),
                createViewControllerWithColor(UIColor.msr_randomColor(opaque: true)),
                createViewControllerWithColor(UIColor.msr_randomColor(opaque: true)),
                createViewControllerWithColor(UIColor.msr_randomColor(opaque: true)),
                createViewControllerWithColor(UIColor.msr_randomColor(opaque: true)),
                createViewControllerWithColor(UIColor.msr_randomColor(opaque: true)),], animated: false)
        }
    }
}
