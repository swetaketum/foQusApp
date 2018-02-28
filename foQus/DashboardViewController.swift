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
    var menuName = [String : Int]()
    
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
            testButton1.setTitle(name.key, for: .normal)
           //testButton1.backgroundColor = UIColor.black
            testButton1.setTitleColor(UIColor.black, for: .normal)
            testButton1.tag = name.value
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
        lblMessage.text = sender.currentTitle
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
                do
                {
                    let jsonString = String(data: receivedData, encoding: String.Encoding.utf8)
                    print(jsonString ?? "no value")
                    let chartData = try Welcome(jsonString!)
                    print(chartData)
                    var dataSets : [LineChartDataSet] = [LineChartDataSet]()
                    let dataFiles = chartData.data.datafiles
                    
                    var index : Double = 0.0;
                    for file in dataFiles
                    {
                        var sum : Double = 0.0
                        for analyte in file.analytes
                        {
                            sum += analyte.rt
                        }
                        let valueData = ChartDataEntry(x: index, y: sum / (Double)(file.analytes.count))
                        var dataArray = [ChartDataEntry]()
                        dataArray.append(valueData)
                        let set1 = LineChartDataSet(values: dataArray, label: file.fileName)
                        set1.axisDependency = .left// Line will correlate with left axis values
                        let setColor : UIColor = self.generateRandomColor()
                        set1.setColor(setColor.withAlphaComponent(0.5))
                        set1.setCircleColor(setColor)
                        set1.lineWidth = 2.0
                        set1.circleRadius = 6.0
                        set1.fillAlpha = 65 / 255.0
                        set1.fillColor = setColor
                        set1.highlightColor = setColor
                        dataSets.append(set1)
                        index += 10
                    }
                    
                    //4 - pass our months in for our x-axis label value along with our dataSets
                    let data: LineChartData = LineChartData(dataSets: dataSets)
                    //(xVals: months, dataSets: dataSets)
                    data.setValueTextColor(UIColor.white)
                    
                    DispatchQueue.main.async {
                        
                        //5 - finally set our data
                        self.ChartsView.data = data
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
    
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
