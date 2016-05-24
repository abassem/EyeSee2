//
//  CameraViewController.swift
//  AA_EyeSee
//
//  Created by Abdo Assem on 5/10/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, OpenCVWrapperDelegate, GestureRecognizerDelegate {

    //  @IBOutlet weak var transpartentView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startCapture: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet weak var touchView: GestureRecognizer!
    
    var changeWalletMoney = true
    //moneyAmountFound
    
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
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
            let documentsDirectory = paths[0] as! String
            let path = documentsDirectory + "/Wallet"
            
            
            
            if let gesture = gesture as? UISwipeGestureRecognizer{
                if gesture.direction == .Left && gesture.numberOfTouchesRequired == 1 {
                    

                    let value = NSMutableDictionary(contentsOfFile: path)
        
                    let walletValue = value!.objectForKey("Wallet") as! Int
                    print(walletValue)
                    // get balance from Plist = walletValue
                    print(wrapper.moneyFound)
                    let totalWalletValue = NSNumber(int: walletValue + wrapper.moneyFound)
                    print(totalWalletValue)
                    
                    let resultDictionary = NSMutableDictionary(contentsOfFile: path)
                    print(resultDictionary)
                    let dict: NSMutableDictionary = [:]
                    
                    dict.setObject(totalWalletValue, forKey: "Wallet")
                    
                    let works = dict.writeToFile(path, atomically: true) as Bool
                    
                    if works == true {
                        print("it works")
                    } else {
                        print("it fails")
                    }

                    
                    

                } else if gesture.direction == .Right && gesture.numberOfTouchesRequired == 1 {
                    
                    let value = NSMutableDictionary(contentsOfFile: path)
                    
                    let walletValue = value!.objectForKey("Wallet") as! Int
                    print(walletValue)
                    // get balance from Plist = walletValue
                    
                    let totalWalletValue = NSNumber(int: Int32(walletValue) - wrapper.moneyFound)
                    
                    let path = documentsDirectory + "/Wallet"
                    
                    let resultDictionary = NSMutableDictionary(contentsOfFile: path)
                    print(resultDictionary)
                    let dict: NSMutableDictionary = [:]
                    
                    dict.setObject(totalWalletValue, forKey: "Wallet")
                    let works = dict.writeToFile(path, atomically: true) as Bool
                    
                    if works == true {
                        print("it works")
                    } else {
                        print("it fails")
                    }
                }
            }
        }
    }
    
    func found() {
        // read out the money value
        // stop Camera
        // add gesture
        if changeWalletMoney == true {
            
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CameraViewController.swiped(_:)))
            self.view.addGestureRecognizer(gestureRecognizer)
            changeWalletMoney = false

        } else {
            changeWalletMoney = true
        }
    }

}

