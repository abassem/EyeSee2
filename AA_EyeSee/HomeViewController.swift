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
        
        let paths = NSBundle.mainBundle().pathForResource("Wallet", ofType: "plist")
        let value = NSMutableDictionary(contentsOfFile: paths!)
        
        if let walletValue = value!.objectForKey("Wallet") as? NSNumber
        {
            self.balanceLabel.text = "\(walletValue)"
        }
        
    }

    @IBOutlet weak var scannerButtonPressed: UIButton!

    
}
