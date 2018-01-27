//
//  ViewController.swift
//  Compass.me
//
//  Created by Cemi Rrahel on 07/11/2017.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//
//  Controller for the login-view (handles user authentication). Authentication step skips, if the user is already logged in (using UserDefaults)

import UIKit
import Foundation


class ViewController: UIViewController {

    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var username_field: UITextField!
    
   
    func gotoNextView(animate: Bool)->Void{
        print("switching view")
        DispatchQueue.main.async {
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "mainMenu")
            self.navigationController?.pushViewController(nextView!, animated: animate)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "loginView"
        self.hideKeyboardWhenTappedAround()
        // username already saved?
        let loadedUsername = UsernameHandler.loadUsername()
        if (loadedUsername != "") {
            gotoNextView(animate: false)
        } else {
            print("user is not persisted")
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
    
    func sendLogin(username: String) {
        let spinner = displaySpinner(onView: self.view)
        var request = URLRequest(url: URL(string: UrlConstants.loginUrl )!)
        request.httpMethod = "POST"
        let params = ["id":username]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else { // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            let httpStatus = (response as? HTTPURLResponse)?.statusCode
            if (httpStatus == 201) {
                print("user is created")
                UsernameHandler.persistUsername(userName: username)
                self.gotoNextView(animate: true)
            } else {
                print("user is already in use")
                self.removeSpinner(spinner: spinner)
                self.openAlert()
            }
        }
        task.resume()
    }

    @IBAction func login_btn(_ sender: Any) {
        guard username_field.text != "" else {
            return
        }
        print("checking name")
        sendLogin(username: username_field.text!)
    }
    
    private func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    
    private func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
