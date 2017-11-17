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
  
    public struct GeographicCoordinates{
        var longitude = 0.0, latitude = 0.0
    }
    public struct FriendLocation {
        var currentLocation = GeographicCoordinates();
        var cooridinates : GeographicCoordinates {
            get{
                return GeographicCoordinates (longitude: currentLocation.longitude, latitude: currentLocation.latitude)
            }
            set(newLocation){
                currentLocation.latitude = newLocation.latitude
                currentLocation.longitude = newLocation.longitude
            }
        }
    }
    @IBAction func rotateImage(_ sender: Any) {
        
        UIView.animate(withDuration: 1.0) {
             self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
   
    func calculateRotation(){
    
        
        
        
    }
    
    
}
