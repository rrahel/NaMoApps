//
//  FindFriend.swift
//  Compass.me
//
//  Created by Rauch Cornelia on 10/11/2017.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//
/*
 Updates location from current user and friend. With the help of a timer the friends
 location is updated every 15 seconds.
 According to the users current location and friend location the arrow rotates in the direction of the
 friend and shows the approximate distance.
 */


import Foundation

import UIKit
import Foundation
import CoreLocation

class FindFriend: UIViewController , CLLocationManagerDelegate {
    var user: User!
    var locationAdjuster: LocationAdjuster!
    var userFromDatabase: User!
    var myTimer: Timer? = nil
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var latitude = 0.0
    var longitude = 0.0
    var angle = 0.0
    
    
    override func viewDidLoad() {
        self.locationAdjuster = LocationAdjuster(findFriend: self)
        getCurrentLocation()
        self.userFromDatabase = user;
        let friendlatitude = user.lat.ToCGFloat()
        let friendlongitude = user.lng.ToCGFloat()
        print("USER LAT: \(friendlatitude)")
        print("USER LNG: \(friendlongitude)")
        
        //call friend location update
        initalTimer()
        locationAdjuster.friendLocation = LocationAdjuster.FriendLocation(currentLocation: LocationAdjuster.GeographicCoordinates(longitude: friendlongitude, latitude:friendlatitude), heading: 0.0)
        
        usernameLabel.text = user.name
    }
    
    //get friend new location
    @objc public func updateUserData(){
        print("Timer called");
        self.loadUser()
        self.locationAdjuster.friendLocation = LocationAdjuster.FriendLocation(currentLocation: LocationAdjuster.GeographicCoordinates(longitude: self.userFromDatabase.lng.ToCGFloat(), latitude: self.userFromDatabase.lat.ToCGFloat()), heading: 0.0)
    }
    
    
    public func initalTimer(){
        myTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(updateUserData), userInfo: nil, repeats: true)
    }
    
    public func rotateImageWithLocation(radians: CGFloat) {
        UIView.animate(withDuration: 1.0) {
            print(" Radians: \(radians)")
            self.arrowImage.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
    var locationManager = CLLocationManager()
    func getCurrentLocation() {
        // keep informed of user's position
        locationManager.delegate = self
        // set accuracy level
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        // request user position authorization
        locationManager.requestWhenInUseAuthorization()
        // start location fetching
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    func loadUser()->Void{
        let urlStr = UrlConstants.listUrl + "/" + user.name
        
        if let url = URL(string: urlStr) {
            if let d = try? Data(contentsOf: url) {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: d as Data) as! [String:AnyObject]
                    print(" Userdata \(parsedData)")
                    userFromDatabase = User(dictionary: parsedData)
                }catch let err{
                    print("E: \(err)")
                }
            }else{
                print("List could not be loaded")
            }
        }
    }
    
    
    func updateArrow() {
        let lat = CGFloat(self.latitude)
        let lng = CGFloat(self.longitude)
        var heading = CGFloat(self.angle)
        print("OWN LAT: \(self.latitude)")
        print("OWN LNG: \(self.longitude)")
        print("Angle: \(self.angle)")
        locationAdjuster.myCurrentLocation = LocationAdjuster.FriendLocation(currentLocation: LocationAdjuster.GeographicCoordinates(longitude: lng, latitude:lat), heading: heading)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        self.latitude = userLocation.coordinate.latitude
        self.longitude = userLocation.coordinate.longitude
        
        updateArrow()
    }
    private func orientationAdjustment() -> CGFloat {
        let isFaceDown: Bool = {
            switch UIDevice.current.orientation {
            case .faceDown: return true
            default: return false
            }
        }()
        let adjAngle: CGFloat = {
            switch UIDevice.current.orientation {
            case .landscapeLeft:  return 90
            case .landscapeRight: return -90
            case .portrait, .unknown: return 0
            case .portraitUpsideDown: return isFaceDown ? 180 : -180
            default: return 0
            }}()
        return adjAngle
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        var angleInRadians = CGFloat(newHeading.trueHeading).toRadians
        angleInRadians = self.orientationAdjustment().toRadians + angleInRadians
        self.angle = Double(angleInRadians)
        updateArrow()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to let others find you we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

