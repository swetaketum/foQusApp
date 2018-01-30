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
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let params = ["username":username.text, "password":password.text] as Dictionary<String, AnyObject>
        
        let urlString = NSString(format: "http://optystech.com/rest/rest-auth/login/");
        print("url string is \(urlString)")
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = URL(string: ((((NSString(format: "%@", urlString)as String) as String) as String) as String) as String)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody  = try! JSONSerialization.data(withJSONObject: params, options: [])
        print(request.httpBody as Any);
        let dataTask = session.dataTask(with: request as URLRequest)
        {
            ( data: Data?, response: URLResponse?, error: Error?) -> Void in
            // 1: Check HTTP Response for successful request
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                
                let resp = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                print(resp as Any)
                
                if (resp != nil)
                {
                    print(resp as Any)
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign In", message:
                            "Success", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign In", message:
                            "Error", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            default:
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Sign In", message:
                        "Invalid Credentials", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        dataTask.resume()
    }
}

