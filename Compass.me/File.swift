//
//  File.swift
//  Compass.me
//
//  Created by Rauch Cornelia on 17/11/2017.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    var toRadians: CGFloat { return self * .pi / 180 }
    var toDegrees: CGFloat { return self * 180 / .pi }
}
public class LocationAdjuster {
    
    var findFriend: FindFriend!
    
    init(findFriend: FindFriend){
        self.findFriend = findFriend
    }
    var distanceBetween:CGFloat = 0.0;
    
    public struct GeographicCoordinates{
        var longitude: CGFloat = 0.0, latitude: CGFloat = 0.0
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
    
     var myCurrentLocation: FriendLocation = FriendLocation(currentLocation: GeographicCoordinates(longitude: 0, latitude: 0))  {
            didSet {
                distanceBetween = calculateDistance(myLocation: myCurrentLocation, friendLocation: friendLocation)
                print("\(distanceBetween)");
                findFriend.rotateImageWithLocation(radians: distanceBetween)
               
            }
    }
    
    public var friendLocation: FriendLocation = FriendLocation(currentLocation: GeographicCoordinates(longitude: 0, latitude: 0)) {
        didSet {
            distanceBetween = calculateDistance(myLocation: myCurrentLocation, friendLocation: friendLocation);
            print("\(distanceBetween)");
             findFriend.rotateImageWithLocation(radians: distanceBetween)
        }
    }
    
    
   func calculateDistance(myLocation: FriendLocation, friendLocation: FriendLocation )-> CGFloat{
    
    let lat1 = myLocation.currentLocation.latitude.toRadians
    let lon1 = myLocation.currentLocation.longitude.toRadians
    
    let lat2 = friendLocation.currentLocation.latitude.toRadians
    let lon2 = friendLocation.currentLocation.longitude.toRadians
    
    let dLon = lon2 - lon1
    
    let y = sin(dLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
    let radiansBearing = atan2(y, x)
    
    return CGFloat(radiansBearing)
    }
}
