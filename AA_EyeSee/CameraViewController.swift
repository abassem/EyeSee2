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

class CameraViewController: UIViewController, OpenCVWrapperDelegate, GestureRecognizerDelegate {

    //  @IBOutlet weak var transpartentView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startCapture: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet weak var touchView: GestureRecognizer!
    
    var notes = [Note]()
    
    var changeWalletMoney = true
    var managedContext: NSManagedObjectContext!
    //moneyAmountFound
    
//    let videoCamera : CvVideoCamera?
    var wrapper : OpenCVWrapper!
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        
        
//        self.view.accessibilityElementsHidden = true
        self.wrapper = OpenCVWrapper()
        wrapper.delegate = self
        wrapper.initMoney()
        super.viewDidLoad()
        
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
                    
                    self.saveValue()
                    
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
                    
                    self.deductValue()
                    
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
    
} // final closing bracket

