//
//  File.swift
//  Compass.me
//
//  Created by Rauch Cornelia on 17/11/2017.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//

import Foundation

extension Double {
    var toRadians: Double { return self * .pi / 180 }
    var toDegrees: Double { return self * 180 / .pi }
}
public class LocationAdjuster {
        var distanceBetween:Double = 0.0;
    
   var myCurrentLocation: FindFriend.FriendLocation = FindFriend.FriendLocation(currentLocation: FindFriend.GeographicCoordinates(longitude: 0, latitude: 0)){

            willSet(newDistance) {
            }
            didSet {
                distanceBetween = calculateDistance(myLocation: myCurrentLocation, friendLocation: friendLocation)
            }
    }
    
    var friendLocation: FindFriend.FriendLocation = FindFriend.FriendLocation(currentLocation: FindFriend.GeographicCoordinates(longitude: 0, latitude: 0)) {
        willSet(newDistance) {
        }
        didSet {
            distanceBetween = calculateDistance(myLocation: myCurrentLocation, friendLocation: friendLocation)
        }
    }
    
    
   func calculateDistance(myLocation: FindFriend.FriendLocation, friendLocation: FindFriend.FriendLocation )->Double{
    
    let lat1 = myLocation.currentLocation.latitude.toRadians
    let lon1 = myLocation.currentLocation.longitude.toRadians
    
    let lat2 = friendLocation.currentLocation.latitude.toRadians
    let lon2 = friendLocation.currentLocation.longitude.toRadians
    
    let dLon = lon2 - lon1
    
    let y = sin(dLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
    let radiansBearing = atan2(y, x)
    
    return Double(radiansBearing)
    }
}
