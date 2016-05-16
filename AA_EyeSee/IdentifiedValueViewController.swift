//
//  IdentifiedValueViewController.swift
//  AA_EyeSee
//
//  Created by Joanne Lim on 11/5/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

import UIKit

class IdentifiedValueViewController: UIViewController, GestureRecognizerDelegate {

    @IBOutlet weak var touchyView: GestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.touchyView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swiped(gesture: UIGestureRecognizer) {
        if gesture.isKindOfClass(UISwipeGestureRecognizer){
            if let gesture = gesture as? UISwipeGestureRecognizer{
                if gesture.direction == .Left && gesture.numberOfTouchesRequired == 2 {
                    self.performSegueWithIdentifier("gestureLeftySegue", sender: nil)
                    print ("left segue")
                } else if gesture.direction == .Right && gesture.numberOfTouchesRequired == 2 {
                    self.performSegueWithIdentifier("gestureRightySegue", sender: nil)
                    print ("right segue")
                } else if gesture.direction == .Down && gesture.numberOfTouchesRequired == 2 {
                    print ("home page")
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("main") as! ViewController
                    self.presentViewController(nextViewController, animated:true, completion:nil)
                }
            }
        }
    }

    

}
