//
//  TodayViewController.swift
//  WidgetView
//
//  Created by Graham Voysey on 11/18/14.
//  Copyright (c) 2014 Graham Voysey. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding, NSXMLParserDelegate {
    
    
    @IBOutlet var frenchToastLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.preferredContentSize = CGSizeMake(320, 50);
        self.updateFrenchToastLevel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func updateFrenchToastLevel() {
        self.frenchToastLabel.textColor = UIColor.lightGrayColor()
        self.frenchToastLabel.text = "Loading ..."
        var url:NSURL = NSURL(string:"http://www.universalhub.com/toast.xml")!
        var error: NSError?
        var data:NSData = NSData(contentsOfURL: url)!
        
        if let xmlDoc = AEXMLDocument(xmlData: data, error: &error){
            var level = xmlDoc.rootElement["status"].value
            switch level{
                case "Low":
                    self.frenchToastLabel.backgroundColor = UIColor(red: 151, green:255, blue:155, alpha:0.9)
                case "Guarded":
                    self.frenchToastLabel.backgroundColor = UIColor(red: 151, green:153, blue: 255, alpha:0.9)
                case "Elevated":
                    self.frenchToastLabel.backgroundColor = UIColor(red: 255, green:255, blue: 64, alpha:0.9)
                case "High":
                    self.frenchToastLabel.backgroundColor = UIColor(red: 255, green:130, blue: 29, alpha:0.9)
                case "Severe":
                    self.frenchToastLabel.backgroundColor = UIColor(red: 248, green:93, blue: 88, alpha:0.9)
                default:
                    break
            }
            self.frenchToastLabel.textColor = UIColor.blackColor()
            self.frenchToastLabel.text = level
        }
    }
}

// from http://stackoverflow.com/questions/24074257/how-to-use-uicolorfromrgb-value-in-swift/25276178#25276178
extension UIColor {
        convenience init(rgb: UInt) {
            self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgb & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
}