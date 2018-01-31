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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
