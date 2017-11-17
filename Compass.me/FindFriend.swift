//
//  FindFriend.swift
//  Compass.me
//
//  Created by Rauch Cornelia on 10/11/2017.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//

import Foundation

import UIKit
import Foundation

class FindFriend: UIViewController {
    
    @IBOutlet weak var arrowImage: UIImageView!
    
    @IBOutlet weak var rotateImageButton: UIButton!
    
    
    @IBAction func rotateImage(_ sender: Any) {
        
        UIView.animate(withDuration: 1.0) {
            self.arrowImage.transform = __CGAffineTransformMake(1,0,1,1,0,0)
        }
    }
    
    
}
