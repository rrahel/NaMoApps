//
//  ViewController.swift
//  Compass.me
//
//  Created by Cemi Rrahel on 07/11/2017.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//
//  Main menu - just buttons, nothing to see here

import UIKit
import Foundation

class MainMenu: UIViewController {
    
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated:true);
        super.viewDidLoad()
        NotificationHelper.sendNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


