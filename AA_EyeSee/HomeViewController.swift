//
//  HomeViewController.swift
//  bit
//
//  Created by Joanne Lim on 23/5/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {
        
    }
    
    var wallet = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let fileManager = NSFileManager.defaultManager()
        
        let path = documentsDirectory + "/Wallet"
        
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("Wallet", ofType: "plist") {
                
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                }catch{
                    print("error copying")
                }
                
            } else {
                print("Wallet.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("Wallet.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory + "/Wallet"
        let value = NSMutableDictionary(contentsOfFile: path)
        
        if let walletValue = value!.objectForKey("Wallet") as? NSNumber
        {
            self.balanceLabel.text = "You Currently have \(walletValue) RM, Press on the Lower part of the screen to Scan again"
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Wallet")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            wallet = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    @IBOutlet weak var scannerButtonPressed: UIButton!

  
}
