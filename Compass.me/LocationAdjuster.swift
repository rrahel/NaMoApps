//
//  File.swift
//  Compass.me
//
//  Created by Rauch Cornelia on 17/11/2017.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

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
        var heading: CGFloat
    }
    
    var myCurrentLocation: FriendLocation = FriendLocation(currentLocation: GeographicCoordinates(longitude: 0, latitude: 0), heading: 0.0)  {
            didSet {
                distanceBetween = calculateDistance(myLocation: myCurrentLocation, friendLocation: friendLocation)
                findFriend.rotateImageWithLocation(radians: distanceBetween - myCurrentLocation.heading)
                let distance = getDistance(myLocation: myCurrentLocation.currentLocation, friendLocation: friendLocation.currentLocation)
                findFriend.distanceLabel.text = distance
                print("UPDATING DISTANCE: \(distance)")
            }
    }
    
    public var friendLocation: FriendLocation = FriendLocation(currentLocation: GeographicCoordinates(longitude: 0, latitude: 0), heading: 0.0) {
        didSet {
            distanceBetween = calculateDistance(myLocation: myCurrentLocation, friendLocation: friendLocation);
             findFriend.rotateImageWithLocation(radians: distanceBetween - myCurrentLocation.heading)
            let distance = getDistance(myLocation: myCurrentLocation.currentLocation, friendLocation: friendLocation.currentLocation)
            findFriend.distanceLabel.text = distance
            print("UPDATING DISTANCE: \(distance)")
        }
    }
    
    
   func calculateDistance(myLocation: FriendLocation, friendLocation: FriendLocation )-> CGFloat{
    // not actually the distance
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
    
    public func getDistance(myLocation : GeographicCoordinates, friendLocation : GeographicCoordinates) ->  String {
        let my = CLLocation(latitude: Double(myLocation.latitude), longitude: Double(myLocation.longitude))
        let friend = CLLocation(latitude: Double(friendLocation.latitude), longitude: Double(friendLocation.longitude))
        let distanceInMeters = my.distance(from: friend)
        
        let roundedDistance = roundToTens(x: distanceInMeters)
        
        if (roundedDistance == 0) {
            return "less than 10 meters"
        }
        
        if (roundedDistance > 1000) {
            let kilometers = round(distanceInMeters / 1000)
            return "about \(kilometers) kilometers"
        }
        
        return "about \(roundedDistance) meters"
    }
    
    func roundToTens(x: Double) -> Int {
        return 10 * Int((x / 10.0).rounded(.up))
    }
}
