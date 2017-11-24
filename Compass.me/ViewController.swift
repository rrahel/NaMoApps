//
//  ViewController.swift
//  Compass.me
//
//  Created by Cemi Rrahel on 07/11/2017.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var username_field: UITextField!
    
    func gotoNextView(animate: Bool)->Void{
        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "mainMenu")
        self.navigationController?.pushViewController(nextView!, animated: animate)
    }
    
    func loadUsername()->String{
        let userDefaults = UserDefaults.standard
        if let username = userDefaults.value(
            forKey:"at.fhj.ims.t13.username") {
            return username as! String
        }else{
            return ""
        }
    }
    
    func persistUsername(userName: String)->Void{
        let userDefaults = UserDefaults.standard
        userDefaults.setValue( userName, forKey: "at.fhj.ims.t13.username")
        userDefaults.synchronize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // username already saved?
        let loadedUsername = loadUsername()
        if (loadedUsername != "") {
            gotoNextView(animate: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openAlert(){
        OperationQueue.main.addOperation {
            let alert = UIAlertController(title: "Username", message: "Username already in use.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func login_btn(_ sender: Any) {
        guard username_field.text != "" else {
            return
        }
        
        sendUserNameToServer(userName: username_field!.text!)
    }
    
    func sendUserNameToServer(userName: String) {
        var request = URLRequest(url: URL(string: UrlConstants.loginUrl)!)
        request.httpMethod = "POST"
        let json: [String:Any] = ["id": userName]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                self.openAlert()
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {           // check for http errors
                self.openAlert()
                print("statusCode should be 201, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print(responseString)
            OperationQueue.main.addOperation {
                // login successful, save:
                self.persistUsername(userName: self.username_field.text!)
                // goto next view
                self.gotoNextView(animate: true)
            }
        }
        task.resume()
    }
}
