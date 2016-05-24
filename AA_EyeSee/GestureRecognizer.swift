//
//  GestureRecognizer.swift
//  Gestures
//
//  Created by Joanne Lim on 12/5/16.
//  Copyright © 2016 Daniel Chong. All rights reserved.
//

import UIKit
import AVFoundation

protocol GestureRecognizerDelegate {
    func swiped(gesture: UIGestureRecognizer)
}

class GestureRecognizer: UIView, UIGestureRecognizerDelegate {
    

    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    var delegate: GestureRecognizerDelegate?
    
    var rawPoints:[Int] = []
//    var recognizer:DBPathRecognizer?
//    
//    let synth = AVSpeechSynthesizer()
//    var myUtterance = AVSpeechUtterance(string: "")
//    let texty = "Hi Handsome, this app is so cool"
    
    override func awakeFromNib() {
        self.savedGestures()
    }
//    
//    func minLastY(cost:Int, infos:PathInfos, minValue:Double)->Int {
//        let py:Double = (Double(infos.deltaPoints.last!.y) - Double(infos.boundingBox.top)) / Double(infos.height)
//        return py < minValue ? Int.max : cost
//    }
//    
//    func maxLastY(cost:Int, infos:PathInfos, maxValue:Double)->Int {
//        let py:Double = (Double(infos.deltaPoints.last!.y) - Double(infos.boundingBox.top)) / Double(infos.height)
//        return py > maxValue ? Int.max : cost
//    }
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        rawPoints = []
//        let touch = touches.first
//        let location = touch!.locationInView(self)
//        rawPoints.append(Int(location.x))
//        rawPoints.append(Int(location.y))
//    }
//    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch = touches.first
//        let location = touch!.locationInView(self)
//        rawPoints.append(Int(location.x))
//        rawPoints.append(Int(location.y))
//        
//    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        let recognizer = DBPathRecognizer(sliceCount: 8, deltaMove: 16.0, costMax: 5)
//        
//        recognizer.addModel(PathModel(directions: [3,2,1,0,7,6,5,4], datas:"O"))
//        recognizer.addModel(PathModel(directions: [1,2,3,4,5,6,7,0], datas:"C"))
//        recognizer.addModel(PathModel(directions: [3,1], datas:"L"))
//        recognizer.addModel(PathModel(directions: [1,3], datas:"R"))
//
//        
//        self.recognizer = recognizer
//        
//        var path:Path = Path()
//        path.addPointFromRaw(rawPoints)
//        
//        let gesture:PathModel? = self.recognizer!.recognizePath(path)
//        
//        if gesture != nil {
//            if let letters =  gesture!.datas as? String{
//                if letters == "O"{
//                    
//                    myUtterance = AVSpeechUtterance(string: texty)
//                    myUtterance.rate = 0.3
//                    synth.speakUtterance(myUtterance)
//                    
//                    print ("counterclockwise")
//                    
//                }else if letters == "C"{
//                    print ("clockwise")
//                    
//                    myUtterance = AVSpeechUtterance(string: texty)
//                    myUtterance.rate = 0.3
//                    synth.speakUtterance(myUtterance)
//                
//                }else if letters == "L"{
//                    print ("left segue way to be activated")
//                    
//                    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//                    if (device.hasTorch) {
//                        do {
//                            try device.lockForConfiguration()
//                            if (device.torchMode == AVCaptureTorchMode.On) {
//                                device.torchMode = AVCaptureTorchMode.Off
//                            } else {
//                                try device.setTorchModeOnWithLevel(1.0)
//                            }
//                            device.unlockForConfiguration()
//                        } catch {
//                            print(error)
//                        }
//                        
//                    }
//  
//                    
//                }else if letters == "R"{
//                    print ("right segue way to be activated")
//                    
//                }else {
//                    print ("undetected")
//                }
//            } else {
//                print ("undetected")
//            }
//        }else{
//            print ("undetected")
//        }
//    }
//    
    func savedGestures() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GestureRecognizer.handleSwipe(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeRight.numberOfTouchesRequired = 1
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GestureRecognizer.handleSwipe(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeLeft.numberOfTouchesRequired = 1
        self.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GestureRecognizer.handleSwipe(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        swipeDown.numberOfTouchesRequired = 1
        self.addGestureRecognizer(swipeDown)
        
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleSwipe(gesture: UIGestureRecognizer){
        self.delegate?.swiped(gesture)
    }
}
