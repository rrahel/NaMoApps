//
//  LocationModel.swift
//  Compass.me
//
//  Created by Rauch Cornelia on 17/11/2017.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//
/*
 Helper class for location model
 */

import Foundation

public class LocationModel {
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
    }}
