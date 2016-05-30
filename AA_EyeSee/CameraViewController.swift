//
//  CameraViewController.swift
//  AA_EyeSee
//
//  Created by Abdo Assem on 5/10/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class CameraViewController: UIViewController, OpenCVWrapperDelegate {
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

    
    var notes = [Note]()
    
    var changeWalletMoney = true
    var managedContext: NSManagedObjectContext!
    //moneyAmountFound
    
    @IBAction func rescanMoney(sender: UIButton) {
        self.beginScanning()
    }
    //    let videoCamera : CvVideoCamera?
    
    @IBOutlet weak var deductValueLabel: UIButton!
    @IBAction func onPressDeductButton(sender: UIButton) {
        self.deductValue()
        self.deductFromWallet()
    }
    
    @IBOutlet weak var addValueLabel: UIButton!

    @IBAction func onPressAddValue(sender: UIButton) {
        self.saveValue()
        self.addToWallet()
    }
    
    var wrapper : OpenCVWrapper!
    override func viewDidLoad() {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        
        


        super.viewDidLoad()
        
   
   
        self.beginScanning()
        
        
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func beginScanning(){
        self.addValueLabel.hidden=true
        self.deductValueLabel.hidden=true
        self.scanningLabel.hidden=true
        self.scanTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(didfindSomething), userInfo: nil, repeats: true)
        //        self.view.accessibilityElementsHidden = true

        self.wrapper = OpenCVWrapper()
        wrapper.delegate = self
        wrapper.initMoney()
        


//        self.touchView.accessibilityFrame = touchView.frame
//        self.touchView.accessibilityTraits = UIAccessibilityTraitButton

        
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
   
        self.rescanButtonOutlet.hidden=true

    }
    
    @IBAction func onStopButtonPressed(sender: AnyObject) {
        self.wrapper.stopCamera();
    }
    
    //handle swipe guestures
    func addToWallet(){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory + "/Wallet"
        
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
        
    }
    func deductFromWallet() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory + "/Wallet"
        
    
                    let value = NSMutableDictionary(contentsOfFile: path)
                    
                    let walletValue = value!.objectForKey("Wallet") as! Int
                    print(walletValue)
                    // get balance from Plist = walletValue
                    
                    let totalWalletValue = NSNumber(int: Int32(walletValue) - wrapper.moneyFound)
                    
        
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
    



    func found() {

        self.addValueLabel.hidden=false
        self.deductValueLabel.hidden=false
        self.rescanButtonOutlet.hidden=false
        self.foundSomething=true
        if changeWalletMoney == true {
            
           
            
            changeWalletMoney = false
            
        } else {
            changeWalletMoney = true
        }
    }

    
    func saveValue(){
        
        let note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: managedContext) as? Note
        
        note?.value = NSNumber(int: wrapper.moneyFound)
        
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deductValue(){
        let request = NSFetchRequest(entityName: "Note")
        
        request.predicate = NSPredicate(format: "value = %@", NSNumber(int: wrapper.moneyFound))
        
        do {
            notes = try managedContext.executeFetchRequest(request) as! [Note]
        }catch{
            print("failed to fetch request")
        }
        
        if(notes.count > 0){
            managedContext.deleteObject(notes.first!)
        }else{
            print("note not found")
        }
        
    }
    
 // final closing bracket

    func didfindSomething() {
        
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

