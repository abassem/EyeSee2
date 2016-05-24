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
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
            let documentsDirectory = paths[0] as! String
            
            let fileManager = NSFileManager.defaultManager()
            
            if let gesture = gesture as? UISwipeGestureRecognizer{
                if gesture.direction == .Left && gesture.numberOfTouchesRequired == 1 {
                    
                    let paths = NSBundle.mainBundle().pathForResource("Wallet", ofType: "plist")
                    let value = NSMutableDictionary(contentsOfFile: paths!)
        
                    let walletValue = value!.objectForKey("Wallet") as! Int
                    print(walletValue)
                    // get balance from Plist = walletValue
                    
                    let totalWalletValue = NSNumber(int: walletValue + wrapper.moneyFound)
                    
                    let path = documentsDirectory + "/Wallet"
                    
                    if(!fileManager.fileExistsAtPath(path)) {
                        // If it doesn't, copy it from the default file in the Bundle
                        if let bundlePath = NSBundle.mainBundle().pathForResource("Wallet", ofType: "plist") {
                            
                            do {
                                try fileManager.copyItemAtPath(bundlePath, toPath: path)
                            }catch{
                                print("error copying")
                            }
                            
                        } else {
                            print("Wallet.plist not found. Please, make sure it is part of the bundle.")
                        }
                    } else {
                        print("Wallet.plist already exits at path.")
                        // use this to delete file from documents directory
                        //fileManager.removeItemAtPath(path, error: nil)
                    }
                    
                    let resultDictionary = NSMutableDictionary(contentsOfFile: path)
                    print(resultDictionary)
                    let dict: NSMutableDictionary = [:]
                    
                    dict.setObject(totalWalletValue, forKey: walletValue)

                } else if gesture.direction == .Right && gesture.numberOfTouchesRequired == 1 {
                    let paths = NSBundle.mainBundle().pathForResource("Wallet", ofType: "plist")
                    let value = NSMutableDictionary(contentsOfFile: paths!)
                    
                    let walletValue = value!.objectForKey("Wallet") as! Int
                    print(walletValue)
                    // get balance from Plist = walletValue
                    
                    let totalWalletValue = NSNumber(int: wrapper.moneyFound - walletValue)
                    
                    let path = documentsDirectory + "/Wallet"
                    
                    if(!fileManager.fileExistsAtPath(path)) {
                        // If it doesn't, copy it from the default file in the Bundle
                        if let bundlePath = NSBundle.mainBundle().pathForResource("Wallet", ofType: "plist") {
                            
                            do {
                                try fileManager.copyItemAtPath(bundlePath, toPath: path)
                            }catch{
                                print("error copying")
                            }
                            
                        } else {
                            print("Wallet.plist not found. Please, make sure it is part of the bundle.")
                        }
                    } else {
                        print("Wallet.plist already exits at path.")
                        // use this to delete file from documents directory
                        //fileManager.removeItemAtPath(path, error: nil)
                    }
                    
                    let resultDictionary = NSMutableDictionary(contentsOfFile: path)
                    print(resultDictionary)
                    let dict: NSMutableDictionary = [:]
                    
                    dict.setObject(totalWalletValue, forKey: walletValue)
                    print ("helloooo")
                }
            }
        }
    }
    
    func found() {
        // read out the money value
        // stop Camera
        // add gesture
        if changeWalletMoney == true {
            
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swiped(_:)))
            self.view.addGestureRecognizer(gestureRecognizer)
            changeWalletMoney = false

        } else {
            changeWalletMoney = true
        }

    }

}

