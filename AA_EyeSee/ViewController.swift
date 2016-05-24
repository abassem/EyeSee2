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

    @IBOutlet weak var touchView: GestureRecognizer!
    
    
    
//    let videoCamera : CvVideoCamera?
    var wrapper : OpenCVWrapper!
    override func viewDidLoad() {
//        self.view.accessibilityElementsHidden = true
        self.wrapper = OpenCVWrapper()
        wrapper.delegate = self
        wrapper.initMoney()
        super.viewDidLoad()
        
//        self.startCapture.hidden = true
//        self.stopButton.hidden = true
        
        self.touchView.delegate = self
        self.touchView.isAccessibilityElement = true
//        self.touchView.accessibilityFrame = touchView.frame
//        self.touchView.accessibilityTraits = UIAccessibilityTraitButton


    }
 //delete after development (start camera automatically)
    @IBAction func onStartButtonPressed(sender: AnyObject) {
        self.wrapper.startCamera(self.imageView, alt: mainImageView)
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureTorchMode.On) {
                    print("already on")
                } else {
                    try device.setTorchModeOnWithLevel(1.0)
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }

    //delete after development (start camera automatically)
    @IBAction func onStopButtonPressed(sender: AnyObject) {
        self.wrapper.stopCamera();
    }
    
    //handle swipe guestures
    func swiped(gesture: UIGestureRecognizer) {
        if gesture.isKindOfClass(UISwipeGestureRecognizer){
            if let gesture = gesture as? UISwipeGestureRecognizer{
                if gesture.direction == .Left && gesture.numberOfTouchesRequired == 1 {
                    
                    let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
                    let value = NSDictionary(contentsOfFile: path!)
        
                    let walletValue = value!.objectForKey("wallet") as! Int32
                    print(walletValue)
                    // get balance from Plist = walletValue
                    
                    let totalWalletValue = walletValue + wrapper.moneyFound
                    
                    
                    // GetValue from Wrapper + wallet value
                    
                    // send walletvalue back to store in Plist
                    
                    
                    print ("wartttt")
                } else if gesture.direction == .Right && gesture.numberOfTouchesRequired == 1 {

                    print ("helloooo")
                }
            }
        }
    }
    
    func found() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
}

