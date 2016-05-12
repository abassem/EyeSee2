//
//  ViewController.swift
//  AA_EyeSee
//
//  Created by Abdo Assem on 5/10/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, OpenCVWrapperDelegate {

    @IBOutlet weak var transpartentView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startCapture: UIButton!
    @IBOutlet weak var imageView: UIImageView!
//    let videoCamera : CvVideoCamera?
    var wrapper : OpenCVWrapper!
    override func viewDidLoad() {
        self.wrapper = OpenCVWrapper()
        wrapper.delegate = self
        let test = OpenCVWrapper.openCVersionString
        print(test)
        super.viewDidLoad()
        self.transpartentView.backgroundColor = UIColor.clearColor()
        
        //Swipe gestures initialization
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipe(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.transpartentView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleSwipe(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.transpartentView.addGestureRecognizer(swipeLeft)

    }
 //delete after development (start camera automatically)
    @IBAction func onStartButtonPressed(sender: AnyObject) {
        
        self.wrapper.startCamera(self.imageView);
    }

    //delete after development (start camera automatically)
    @IBAction func onStopButtonPressed(sender: AnyObject) {
        self.wrapper.stopCamera();
    }
    
    //handle swipe guestures
    func handleSwipe(gesture: UIGestureRecognizer) {
        if let myGesture = gesture as? UISwipeGestureRecognizer{
            switch myGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                performSegueWithIdentifier("blankLeftGesture", sender: self)
                print ("Left")
                
                
            case UISwipeGestureRecognizerDirection.Right:
                performSegueWithIdentifier("blankRightGesture", sender: self)
                print ("Right")
                
                
                
                
            default:
                break
            }
        }
    }
}

