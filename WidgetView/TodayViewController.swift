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
                    self.frenchToastLabel.backgroundColor = UIColor(rgba: "#97ff9b")
                case "Guarded":
                    self.frenchToastLabel.backgroundColor = UIColor(rgba: "#9799ff")
                case "Elevated":
                    self.frenchToastLabel.backgroundColor = UIColor(rgba: "#ffff40")
                case "High":
                    self.frenchToastLabel.backgroundColor = UIColor(rgba: "#ff821d")
                case "Severe":
                    self.frenchToastLabel.backgroundColor = UIColor(rgba: "#f85d58")
                default:
                    break
            }
            self.frenchToastLabel.textColor = UIColor.blackColor()
            self.frenchToastLabel.text = level
        }
    }
}

extension UIColor {
    convenience init(rgba: String) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        if rgba.hasPrefix("#") {
            let index = advance(rgba.startIndex, 1)
            let hex = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                if countElements(hex) == 6 {
                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if countElements(hex) == 8 {
                    red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF) / 255.0
                } else {
                    print("invalid rgb string, length should be 7 or 9")
                }
            } else {
                println("scan hex error")
            }
        } else {
            print("invalid rgb string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}