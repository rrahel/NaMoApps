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

    override func viewDidLoad() {
        super.viewDidLoad()
        // username already saved?
        let loadedUsername = UsernameHandler.loadUsername()
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
        let result = HttpHandler.httpPost(UrlString: UrlConstants.loginUrl, RequestData: ["id": username_field!.text!])
        if(result.result == false){
            self.openAlert()
        }else{
            UsernameHandler.persistUsername(userName: username_field!.text!)
            self.gotoNextView(animate: true)
        }

    }

}
