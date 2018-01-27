//
//  User.swift
//  Compass.me
//
//  Created by Kogler Christian on 17/11/2017.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//
/*
  Helper class User model
 */

import Foundation
class User {
    let name: String
    let lat: String
    let lng: String
    
    init (dictionary: [String:Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.lat = dictionary["latitude"] as? String ?? ""
        self.lng = dictionary["longitude"] as? String ?? ""
    }
}
