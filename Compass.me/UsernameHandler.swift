//
//  UsernameHandler.swift
//  Compass.me
//
//  Created by Rauch Cornelia on 24.11.17.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//

import Foundation

class UsernameHandler {
    
    class func loadUsername()->String{
        let userDefaults = UserDefaults.standard
        if let username = userDefaults.value(
            forKey:"at.fhj.ims.t13.username") {
            return username as! String
        }else{
            return ""
        }
    }
    
    class func persistUsername(userName: String)->Void{
        let userDefaults = UserDefaults.standard
        userDefaults.setValue( userName, forKey: "at.fhj.ims.t13.username")
        userDefaults.synchronize()
    }
}
