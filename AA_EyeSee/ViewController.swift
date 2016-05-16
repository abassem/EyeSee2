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
    @IBOutlet weak var mainImageView: UIImageView!
//    let videoCamera : CvVideoCamera?
    var wrapper : OpenCVWrapper!
    override func viewDidLoad() {
//        self.view.accessibilityElementsHidden = true
        self.wrapper = OpenCVWrapper()
        wrapper.delegate = self
        let test = OpenCVWrapper.openCVersionString
        print(test)
        super.viewDidLoad()

    }

    @IBAction func onStartButtonPressed(sender: AnyObject) {
        self.wrapper.startCamera(self.imageView, alt: mainImageView)
    }

    
    @IBAction func onStopButtonPressed(sender: AnyObject) {
        self.wrapper.stopCamera();
    }
    

}

