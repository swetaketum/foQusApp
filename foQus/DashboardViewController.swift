//
//  DashboardViewController.swift
//  foQus
//
//  Created by akhila panackal on 31.01.18.
//  Copyright © 2018 Optys Tech Corporation. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var menuConstraint: NSLayoutConstraint!
    var menuShow = false
    var menuName = [String]()
    
    @IBOutlet weak var ProjectsView: UIView!
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var SignOutButton: UIButton!
    @IBOutlet weak var ExperimentsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var counter = 0
        for name in menuName {
            
             print(name)
            let testButton1 = UIButton(type: .roundedRect) as UIButton
            testButton1.frame = CGRect(x: 0, y: counter * 50 , width: 120, height: 50)
            testButton1.setTitle(name, for: .normal)
           //testButton1.backgroundColor = UIColor.black
            testButton1.setTitleColor(UIColor.black, for: .normal)
            testButton1.tag = counter
            testButton1.addTarget(self, action:#selector(menuClicked(sender:)), for: .touchUpInside)
            ExperimentsView.addSubview(testButton1)
            counter = counter + 1
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func SignOutButtonAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "key")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToLogIn", sender: self)
        }
    }
    
    @IBAction func menuShow(_ sender: UIBarButtonItem) {
        if (menuShow){
            menuConstraint.constant = -140
        }
        else {
            menuConstraint.constant = 0
        }
        menuShow = !menuShow
       
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createMenu(){
         print("Inside")
       
        
    }
    @IBAction func menuClicked(sender:UIButton){
        if (menuShow){
            menuConstraint.constant = -140
        }
        else {
            menuConstraint.constant = 0
        }
        menuShow = !menuShow

        let tag = sender.tag as NSNumber
        lblMessage.text = "Exp " + tag.stringValue
        
        if(sender.tag == 0){
            lblMessage.text = "Exp 0"
        }
        
        
    }
}
