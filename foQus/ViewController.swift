//
//  ViewController.swift
//  foQus
//
//  Created by Swetaketu Majumder on 24.01.18.
//  Copyright © 2018 Optys Tech Corporation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var username: DesignableTextField!
    @IBOutlet weak var password: DesignableTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ButtonClick(_ sender: Any) {
        let alertController = UIAlertController(title: "Sign In", message:
            "Username : \(username.text!)\nPassword : \(password.text!)", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)    }
}

