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
        let alert = UIAlertController(title: "Username", message: "Username already in use.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func login_btn(_ sender: Any) {
        guard username_field.text != "" else {
            return
        }
        
        let urlStr = "https://httpstat.us/200"
        if let url = URL(string: urlStr) {
            if let d = try? Data(contentsOf: url) {
                // login successful, save:
                persistUsername(userName: username_field.text!)
                // goto next view
                gotoNextView(animate: true)
            }else{
                openAlert()
            }
        }
    }
}
