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
import CoreLocation

class FindFriend: UIViewController , CLLocationManagerDelegate {
    var user: User!
    var locationAdjuster: LocationAdjuster!

    let refreshrate = 0.1
    var myTimer: Timer? = nil
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var rotateImageButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var latitude = 0.0
    var longitude = 0.0
    var angle = 0.0
    
    override func viewDidLoad() {
        print(user.name)
        self.locationAdjuster = LocationAdjuster(findFriend: self)
        getCurrentLocation()
        print(user.lat)
        print(user.lng)
        //let friendlatitude = CGFloat(NumberFormatter().number(from: user.lat)!)
        //let friendlongitude = CGFloat(NumberFormatter().number(from: user.lng)!)

        myTimer = Timer.scheduledTimer(withTimeInterval: refreshrate, repeats: true, block: { (timer) in
            //self.locationAdjuster.friendLocation = LocationAdjuster.FriendLocation(currentLocation: LocationAdjuster.GeographicCoordinates(longitude: friendlongitude, latitude: friendlatitude), )  todo: api call to request friends location
        })
        
    }
    
    public func rotateImageWithLocation(radians: CGFloat) {
        UIView.animate(withDuration: 1.0) {
            self.arrowImage.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
     var locationManager = CLLocationManager()
    
    func getCurrentLocation() {
        
        // keep informed of user's position
        locationManager.delegate = self
        // set accuracy level
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // request user position authorization
        locationManager.requestWhenInUseAuthorization()
        // start location fetching
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    func updateArrow() {
        let lat = CGFloat(self.latitude)
        let lng = CGFloat(self.longitude)
        var heading = CGFloat(self.angle)
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
