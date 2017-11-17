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
    var user: User!
    
    @IBOutlet weak var arrowImage: UIImageView!
    
    @IBOutlet weak var rotateImageButton: UIButton!
    
    override func viewDidLoad() {
        print(user.name)
    }
    
    @IBAction func rotateImage(_ sender: Any) {
        
        UIView.animate(withDuration: 1.0) {
             self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
    
    
}
