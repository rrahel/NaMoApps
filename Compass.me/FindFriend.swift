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
    var locationAdjuster: LocationAdjuster!
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var rotateImageButton: UIButton!
    
    override func viewDidLoad() {
        print(user.name)
        self.locationAdjuster = LocationAdjuster(findFriend: self)
    }
  
    @IBAction func rotateImage(_ sender: Any) {
        let dice1 = arc4random_uniform(4) + 1;
        calculateRotation(n: dice1);
    }
    
    public func rotateImageWithLocation(radians: CGFloat) {
        UIView.animate(withDuration: 1.0) {
            self.arrowImage.transform = CGAffineTransform(rotationAngle: radians)
        }
    }

    func calculateRotation(n :UInt32){
        
        switch n {
        case 1:
             locationAdjuster.myCurrentLocation = LocationAdjuster.FriendLocation(currentLocation: LocationAdjuster.GeographicCoordinates(longitude: 15, latitude: 10)) ;
        case 2:
             locationAdjuster.friendLocation = LocationAdjuster.FriendLocation(currentLocation: LocationAdjuster.GeographicCoordinates(longitude: 40, latitude: 100)) ;
        case 3:
            locationAdjuster.friendLocation = LocationAdjuster.FriendLocation(currentLocation: LocationAdjuster.GeographicCoordinates(longitude: 100, latitude: 60)) ;
        case 4:
            locationAdjuster.myCurrentLocation = LocationAdjuster.FriendLocation(currentLocation: LocationAdjuster.GeographicCoordinates(longitude: 10, latitude: 5)) ;
        default:
           locationAdjuster.friendLocation = LocationAdjuster.FriendLocation(currentLocation: LocationAdjuster.GeographicCoordinates(longitude: 50, latitude: 60)) ;
        }
        
    }
}
