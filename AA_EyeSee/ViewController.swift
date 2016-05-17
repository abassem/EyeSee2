//
//  ViewController.swift
//  AA_EyeSee
//
//  Created by Abdo Assem on 5/10/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, OpenCVWrapperDelegate, GestureRecognizerDelegate {

    //  @IBOutlet weak var transpartentView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startCapture: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    //   @IBOutlet weak var touchView: GestureRecognizer!
    
//    let videoCamera : CvVideoCamera?
    var wrapper : OpenCVWrapper!
    override func viewDidLoad() {
//        self.view.accessibilityElementsHidden = true
        self.wrapper = OpenCVWrapper()
        wrapper.delegate = self
        let test = OpenCVWrapper.openCVersionString
        print(test)
        super.viewDidLoad()
        
        //   self.touchView.delegate = self


    }
 //delete after development (start camera automatically)
    @IBAction func onStartButtonPressed(sender: AnyObject) {
        self.wrapper.startCamera(self.imageView, alt: mainImageView)
    }

    //delete after development (start camera automatically)
    @IBAction func onStopButtonPressed(sender: AnyObject) {
        self.wrapper.stopCamera();
    }
    
    //handle swipe guestures
    func swiped(gesture: UIGestureRecognizer) {
        if gesture.isKindOfClass(UISwipeGestureRecognizer){
            if let gesture = gesture as? UISwipeGestureRecognizer{
                if gesture.direction == .Left && gesture.numberOfTouchesRequired == 2 {
                    self.performSegueWithIdentifier("gestureLeftSegue", sender: nil)
                    print ("wartttt")
                } else if gesture.direction == .Right && gesture.numberOfTouchesRequired == 2 {
                    self.performSegueWithIdentifier("gestureRightSegue", sender: nil)
                    print ("helloooo")
                }
            }
        }
    }
}

