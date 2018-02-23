//
//  ViewController.swift
//  foQus
//
//  Created by Swetaketu Majumder on 24.01.18.
//  Copyright © 2018 Optys Tech Corporation. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: DesignableTextField!
    @IBOutlet weak var password: DesignableTextField!
    @IBOutlet weak var signin: UIButton!
    @IBAction func unwindToLogIn(segue:UIStoryboardSegue) { }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
        self.username.delegate = self
        self.password.delegate=self
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if let key = UserDefaults.standard.value(forKey: "key")
        {
            getLabDataAndSegue()
            print("already logged in")
        }
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
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: receivedData) as? [String: Any]
                        let key = json!["key"] as? String
                        print(key ?? "no value")
                        UserDefaults.standard.set(key, forKey: "key")
                    }
                    catch
                    {
                        
                    }
                    self.self.getLabDataAndSegue()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
    }
    
    var experiments = [String]()
    func getLabDataAndSegue()
    {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let urlString = NSString(format: "http://optystech.com/foqus-server/v1/lab/");
        print("url string is \(urlString)")
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = URL(string: ((((NSString(format: "%@", urlString)as String) as String) as String) as String) as String)
        request.httpMethod = "GET"
        request.addValue("token " + (UserDefaults.standard.value(forKey: "key") as! String), forHTTPHeaderField: "Authorization")
        //request.httpBody  = try! JSONSerialization.data(withJSONObject: params, options: [])
        //print(request.httpBody as Any);
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

                //print(resp as Any)
                
                do
                {
                    let json = try JSONSerialization.jsonObject(with: receivedData) as? [String: Any]
                    let exp = json!["experiment"] as? [[String: Any]]
                    print(exp ?? "no value")
                    if exp != nil
                    {
                        self.self.experiments.removeAll()
                        for item in exp!
                        {
                            self.self.experiments.append(item["experiment_name"] as! String)
                            print(item["experiment_name"] ?? "no value inside loop")
                        }
                        DispatchQueue.main.async {
                            
                            self.performSegue(withIdentifier: "LoginSegue", sender: self)
                        }
                    }
                }
                catch
                {
                    print("in catch")
                }
                
                break
                
            default:
                print(httpResponse.statusCode)
                break
                
            }
        }
        dataTask.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.childViewControllers[0] is DashboardViewController{
            let myDash = segue.destination.childViewControllers[0] as? DashboardViewController
            for item in experiments
            {
                myDash?.menuName.append(item)
            }
        }
        print(segue.destination.childViewControllers[0])
    }
}

