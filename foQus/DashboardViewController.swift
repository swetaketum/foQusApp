//
//  DashboardViewController.swift
//  foQus
//
//  Created by akhila panackal on 31.01.18.
//  Copyright © 2018 Optys Tech Corporation. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var menuConstraint: NSLayoutConstraint!
    var menuShow = false
    var menuName = [String]()
    
    @IBOutlet weak var ProjectsView: UIView!
    
    @IBOutlet weak var ChartsView: LineChartView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var SignOutButton: UIButton!
    @IBOutlet weak var ExperimentsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChartsView.noDataText = ""
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

        //let tag = sender.tag as NSNumber
        lblMessage.text = menuName[sender.tag]
        setChartValues(sender.tag);
        
    }
    func setChartValues(_ tag : Int = 0){
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let urlString = NSString(format: "http://optystech.com/foqus-server/v1/experiment/\(tag)/data/" as NSString);
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
                    print(json ?? "no value")
                    let months = [1,2,3,4,5]
                    var count = 10
                    var dataArray = [ChartDataEntry]()
                    for month in months{
                        let valueData = ChartDataEntry(x: Double(month), y: Double(arc4random_uniform(UInt32(count))))
                        dataArray.append(valueData)
                        count = count + 10
                    }
                    let set1 = LineChartDataSet(values: dataArray, label: "DataSet")
                    set1.axisDependency = .left// Line will correlate with left axis values
                    set1.setColor(UIColor.blue.withAlphaComponent(0.5))
                    set1.setCircleColor(UIColor.blue)
                    set1.lineWidth = 2.0
                    set1.circleRadius = 6.0
                    set1.fillAlpha = 65 / 255.0
                    set1.fillColor = UIColor.blue
                    set1.highlightColor = UIColor.blue
                    //let data1 = LineChartData(dataSet: set1)
                    // here goes second data set
                    var dataArray2 = [ChartDataEntry]()
                    for month in months{
                        let valueData = ChartDataEntry(x: Double(month), y: Double(arc4random_uniform(UInt32(count))))
                        dataArray2.append(valueData)
                        count = count + 10
                    }
                    let set2 = LineChartDataSet(values: dataArray2, label: "DataSet2")
                    set2.axisDependency = .left// Line will correlate with left axis values
                    set2.setColor(UIColor.yellow.withAlphaComponent(0.5))
                    set2.setCircleColor(UIColor.yellow)
                    set2.lineWidth = 2.0
                    set2.circleRadius = 6.0
                    set2.fillAlpha = 65 / 255.0
                    set2.fillColor = UIColor.yellow
                    set2.highlightColor = UIColor.yellow
                    
                    var dataSets : [LineChartDataSet] = [LineChartDataSet]()
                    dataSets.append(set1)
                    dataSets.append(set2)
                    
                    //4 - pass our months in for our x-axis label value along with our dataSets
                    let data: LineChartData = LineChartData(dataSets: dataSets)
                    //(xVals: months, dataSets: dataSets)
                    data.setValueTextColor(UIColor.white)
                    
                    //5 - finally set our data
                    self.ChartsView.data = data
                    
                }
                catch
                {
                    print("in catch")
                }
                
                break
                
            default:
                print(httpResponse.statusCode)
                break
        // call method to get data here
        // here goes first data set
       
        
        
    }
}
        dataTask.resume()
    }
}
