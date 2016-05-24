//
//  HomeViewController.swift
//  bit
//
//  Created by Joanne Lim on 23/5/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let value = NSDictionary(contentsOfFile: path!)
        let fileManager = NSFileManager.defaultManager()
        
        //check if file exists
        if(!fileManager.fileExistsAtPath(path!)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("Wallet", ofType: "plist") {
                
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle GameData.plist file is --> \(resultDictionary?.description)")
                
                let walletValue = value!.objectForKey("wallet") as! [NSValue]
                self.balanceLabel.text = String(walletValue)
                
                print("copy")
            } else {
                print("Wallet.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("Wallet.plist already exits at path.")

        }
        
    }

    @IBOutlet weak var scannerButtonPressed: UIButton!

    
}
