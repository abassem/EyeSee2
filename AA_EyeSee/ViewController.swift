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

    }

    @IBAction func onStartButtonPressed(sender: AnyObject) {
        
        self.wrapper.startCamera(self.imageView);
    }

    
    @IBAction func onStopButtonPressed(sender: AnyObject) {
        self.wrapper.stopCamera();
    }
    

}

