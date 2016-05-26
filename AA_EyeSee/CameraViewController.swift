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
    @IBOutlet weak var scanningLabel: UILabel!
    
    @IBOutlet weak var rescanButtonOutlet: UIButton!
    //  @IBOutlet weak var transpartentView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startCapture: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    var foundSomething = false
    var scanTimer : NSTimer!
    var audioPlayer: AVAudioPlayer!

    @IBOutlet weak var touchView: GestureRecognizer!
    
    var changeWalletMoney = true
    //moneyAmountFound
    
    @IBAction func rescanMoney(sender: UIButton) {
        self.beginScanning()
    }
    //    let videoCamera : CvVideoCamera?
    var wrapper : OpenCVWrapper!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.touchView.delegate = self
        self.touchView.isAccessibilityElement = true
        
        self.beginScanning()
        
        
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func beginScanning(){
        self.scanningLabel.hidden=true
        self.scanTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(foundSmething), userInfo: nil, repeats: true)
        //        self.view.accessibilityElementsHidden = true
        self.wrapper = OpenCVWrapper()
        wrapper.delegate = self
        wrapper.initMoney()
        
        
        //        self.startCapture.hidden = true
        //        self.stopButton.hidden = true
        
        
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
        self.imageView.hidden=true
        self.touchView.hidden=true
        self.rescanButtonOutlet.hidden=true
    }
    
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
                
                //left direction
                
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
                    
                    self.performSegueWithIdentifier("toHomeVC", sender: self)
                    
                    //right direction
                    
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
                    self.performSegueWithIdentifier("toHomeVC", sender: self)
                    
                }
            }
        }
    }
    
    func found() {

        self.touchView.hidden=false
        self.rescanButtonOutlet.hidden=false
        self.foundSomething=true
        if changeWalletMoney == true {
            
            let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CameraViewController.swiped(_:)))
            self.view.addGestureRecognizer(gestureRecognizer)
            
            changeWalletMoney = false
            
        } else {
            changeWalletMoney = true
        }
    }
    func foundSmething() {
        
        if self.foundSomething==false {
            self.scanningLabel.hidden=false
            
            let scanningSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("scanning", ofType: "mp3")!)
            do{
                audioPlayer = try AVAudioPlayer(contentsOfURL:scanningSound)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }catch {
                print("Error getting the audio file")
            }
            
        }else{
            scanTimer.invalidate()
        }
    }
}

