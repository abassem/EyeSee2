//
//  GestureRecognizer.swift
//  Gestures
//
//  Created by Joanne Lim on 12/5/16.
//  Copyright © 2016 Daniel Chong. All rights reserved.
//

import UIKit

protocol GestureRecognizerDelegate {
    func swiped(gesture: UIGestureRecognizer)
}

class GestureRecognizer: UIView, UIGestureRecognizerDelegate {
    

    // Retreive the managedObjectContext from AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    var delegate: GestureRecognizerDelegate?
    
    var rawPoints:[Int] = []
    var recognizer:DBPathRecognizer?
    
    override func awakeFromNib() {
        self.savedGestures()
    }
    
    func minLastY(cost:Int, infos:PathInfos, minValue:Double)->Int {
        let py:Double = (Double(infos.deltaPoints.last!.y) - Double(infos.boundingBox.top)) / Double(infos.height)
        return py < minValue ? Int.max : cost
    }
    
    func maxLastY(cost:Int, infos:PathInfos, maxValue:Double)->Int {
        let py:Double = (Double(infos.deltaPoints.last!.y) - Double(infos.boundingBox.top)) / Double(infos.height)
        return py > maxValue ? Int.max : cost
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        rawPoints = []
        let touch = touches.first
        let location = touch!.locationInView(self)
        rawPoints.append(Int(location.x))
        rawPoints.append(Int(location.y))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInView(self)
        rawPoints.append(Int(location.x))
        rawPoints.append(Int(location.y))
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let recognizer = DBPathRecognizer(sliceCount: 8, deltaMove: 16.0, costMax: 5)
        
        recognizer.addModel(PathModel(directions: [4,3,2,1,0,7,6,5,4], datas:"O"))
        recognizer.addModel(PathModel(directions: [0,1,2,3,4,5,6,7,0], datas:"C"))
        recognizer.addModel(PathModel(directions: [4], datas:"left"))
        recognizer.addModel(PathModel(directions: [0], datas:"right"))
        
        self.recognizer = recognizer
        
        var path:Path = Path()
        path.addPointFromRaw(rawPoints)
        
        let gesture:PathModel? = self.recognizer!.recognizePath(path)
        
        if gesture != nil {
            if let letters =  gesture!.datas as? String{
                if letters == "O"{
                    
//                    // Initialize Fetch Request
//                    let fetchRequest = NSFetchRequest()
//                    
//                    // Create Entity Description
//                    let entityDescription = NSEntityDescription.entityForName("Wallet", inManagedObjectContext: self.managedObjectContext)
//                    
//                    // Configure Fetch Request
//                    fetchRequest.entity = entityDescription
//                    
//                    do {
//                        let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
//                        print(result)
//                        
//                    } catch {
//                        let fetchError = error as NSError
//                        print(fetchError)
//                    }

                    print ("counterclockwise")
                    
                }else if letters == "C"{
                    print ("clockwise")
                
//                }else if letters == "left"{
//                    print ("left segue way to be activated")
//                    
//                    
//                }else if letters == "right"{
//                    print ("right segue way to be activated")
                    
                }else {
                    print ("undetected")
                }
            } else {
                print ("undetected")
            }
        }else{
            print ("undetected")
        }
    }
    
    func savedGestures() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GestureRecognizer.handleSwipe(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeRight.numberOfTouchesRequired = 2
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GestureRecognizer.handleSwipe(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeLeft.numberOfTouchesRequired = 2
        self.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GestureRecognizer.handleSwipe(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        swipeDown.numberOfTouchesRequired = 2
        self.addGestureRecognizer(swipeDown)
        
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleSwipe(gesture: UIGestureRecognizer){
        self.delegate?.swiped(gesture)
    }
}
