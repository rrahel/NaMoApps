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
    
    @IBOutlet weak var gpsIcon: UIImageView!
    
    
    
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
        let lng = userLocation.coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        sendLocationToServer(lat: location.latitude, lng: location.longitude)
    }
    
    // If we have been deined access give the user the option to change it
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("UserList started")
        getCurrentLocation()
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.gpsIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }) { (value) in
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            //make a request to server to stop the sharing status of the user
        }
    }
    

    
}



