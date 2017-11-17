//
//  ShareLocation.swift
//
//
//  Created by Cemi Rrahel on 10/11/2017.
//


import UIKit
import Foundation
import CoreLocation

class ShareLocation: UIViewController, CLLocationManagerDelegate {
    
    func loadUsername()->String{
        let userDefaults = UserDefaults.standard
        if let username = userDefaults.value(
            forKey:"at.fhj.ims.t13.username") {
            return username as! String
        }else{
            return ""
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
        locationManager.startUpdatingLocation()
        
    }
    
    func sendLocationToServer(lat: Double, lng: Double) {
        let username = loadUsername()
        
        var request = URLRequest(url: URL(string: "https://glacial-waters-86425.herokuapp.com/users/\(username)")!)
        request.httpMethod = "POST"
        let postString = "longitude=\(lng)&latitude=\(lat)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        sendLocationToServer(lat: location.latitude, lng: location.longitude)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UserList started")
        getCurrentLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}



