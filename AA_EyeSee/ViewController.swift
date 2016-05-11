//
//  ViewController.swift
//  AA_EyeSee
//
//  Created by Abdo Assem on 5/10/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        
    }

    override func viewDidAppear(animated: Bool) {
        if UIImagePickerController.isCameraDeviceAvailable( UIImagePickerControllerCameraDevice.Front) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        dismissViewControllerAnimated(true, completion: nil)
        imageView.image = image
    }

}

