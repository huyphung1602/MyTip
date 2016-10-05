//
//  ViewController.swift
//  MyTip
//
//  Created by Quoc Huy on 9/12/16.
//  Copyright © 2016 Huy Phung. All rights reserved.
//

import UIKit
import CoreData
import Foundation

// Variables used for core data
var listItems = [NSManagedObject]()

// Global variables used for background
let image1 = UIImage(named: "background_001.jpg")
let image2 = UIImage(named: "background_002.jpg")

let myOrange = UIColor(red: 255, green: 170, blue:   0, alpha: 1)
let myWhite  = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
let myRed    = UIColor(red: 255, green:   0, blue:   0, alpha: 1)
let myBlack  = UIColor(red:   0, green:   0, blue:   0, alpha: 1)

class ViewController: UIViewController {

    // UI variables
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    @IBOutlet weak var background_mainview: UIImageView!
    
    // Static texts variables
    @IBOutlet weak var billTitle: UILabel!
    @IBOutlet weak var tipTitle: UILabel!
    @IBOutlet weak var totalTitle: UILabel!
    
    struct myArray {
        static var myPercentages = [0.18, 0.20, 0.25]
        static var myBillField   = ""
    }
    
    
    // Money bag picture
    @IBOutlet weak var moneyBag: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get current date
        let currentDate = NSDate()
        
        // Load NSU
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastDate = defaults.objectForKey("last_date") ?? currentDate
        
        // Check if billFieldText is nil or not
        let checkBillFieldText = defaults.objectForKey("billField_text")
        
        var billFieldText = ""
        
        if checkBillFieldText != nil {
            billFieldText = defaults.objectForKey("billField_text") as! String
        }
        
        // Compare the current date with the last time the apps has been used
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: lastDate as! NSDate, toDate: currentDate, options: NSCalendarOptions.init(rawValue: 0))
        
        print("The difference between dates is: \(diffDateComponents.year) years, \(diffDateComponents.month) months, \(diffDateComponents.day) days, \(diffDateComponents.hour) hours, \(diffDateComponents.minute) minutes, \(diffDateComponents.second) seconds")
        
        let diff_plus = diffDateComponents.year + diffDateComponents.month + diffDateComponents.day + diffDateComponents.hour
        
        if (diff_plus == 0) && (diffDateComponents.minute < 10) {
            billField.text = billFieldText
        }
        
        // Set moneyBag pic alpha equal 0
        moneyBag.alpha = 0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        
        // Text field always visible
        billField.becomeFirstResponder()
        
        // Apply current seletected theme
        let defaults = NSUserDefaults.standardUserDefaults()
        let checkNil = defaults.objectForKey("theme_flag")
        
        if checkNil != nil {
            let themeFlag = Int(defaults.objectForKey("theme_flag") as! NSNumber)
            if (themeFlag == 0) {
                background_mainview.image = image1
                
                tipLabel.textColor   = myBlack
                totalLabel.textColor = myBlack
                
                billTitle.textColor  = myBlack
                tipTitle.textColor   = myBlack
                totalTitle.textColor = myBlack
                
                tipControl.tintColor = myRed
                
            } else {
                background_mainview.image = image2
                
                tipLabel.textColor   = myWhite
                totalLabel.textColor = myWhite
                
                billTitle.textColor  = myWhite
                tipTitle.textColor   = myWhite
                totalTitle.textColor = myWhite
                
                tipControl.tintColor = myOrange
                
            }
        }
        
        // Check Flag
        let flag = defaults.objectForKey("save_flag")
        print("\(flag)")
        if flag == nil {
            // Do nothing
            // tipControl.setTitle ("huyphung", forSegmentAtIndex:0)
        } else {
            // Load User percentages
            
            // Percentage 1
            let segment_text_1 = defaults.objectForKey("percent_1_text") as! String
            let segment_value_1 = defaults.objectForKey("percent_1_value")
            let tipPercenttages_1 = Double(segment_value_1 as! NSNumber) * 0.01
            
            // Percentage 2
            let segment_text_2 = defaults.objectForKey("percent_2_text") as! String
            let segment_value_2 = defaults.objectForKey("percent_2_value")
            let tipPercenttages_2 = Double(segment_value_2 as! NSNumber) * 0.01
            
            // Percentage 3
            let segment_text_3 = defaults.objectForKey("percent_3_text") as! String
            let segment_value_3 = defaults.objectForKey("percent_3_value")
            let tipPercenttages_3 = Double(segment_value_3 as! NSNumber) * 0.01
            
            myArray.myPercentages = [tipPercenttages_1, tipPercenttages_2, tipPercenttages_3]
            
            // Change the titles of the Segment
            tipControl.setTitle (segment_text_1, forSegmentAtIndex:0)
            tipControl.setTitle (segment_text_2, forSegmentAtIndex:1)
            tipControl.setTitle (segment_text_3, forSegmentAtIndex:2)
            
            // Calculate the value again after change the ratios
            cal_function()
            
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func calculateTip(sender: AnyObject) {
        
        // Save the value of current billField to a struct var
        myArray.myBillField = billField.text! ?? ""
        
        // Do not let user input "00000.."
        if (billField.text == "00") {
            billField.text = "0"
        }
        
        // Calulate everytime the bill value is changed
        cal_function()
        
    }
    
    // Calculate the tip, total, format their number style
    func cal_function() {
        var tipPercentages = myArray.myPercentages
        
        let bill  = Double(billField.text!) ?? 0
        let tip   = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        // Set the style of result to currency and have the group separator
        let myFormatter = NSNumberFormatter()
        myFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        myFormatter.groupingSeparator = ","
        myFormatter.decimalSeparator = "."
        myFormatter.usesGroupingSeparator = true
        myFormatter.minimumFractionDigits = 2
        myFormatter.minimumIntegerDigits  = 1
        
        tipLabel.text   = myFormatter.stringFromNumber(tip)
        totalLabel.text = myFormatter.stringFromNumber(total)
    }
    
    // Save paid data
    @IBAction func saveHistory(sender: AnyObject) {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm:ss"
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        
        saveItem(totalLabel.text!, billDate: convertedDate)
        
        let myItem = listItems[listItems.count - 1]
        print ("\(myItem.valueForKey("totalAmount") as! String)")
        print ("\(myItem.valueForKey("paidDate") as! String)")
        
        UIView.animateWithDuration(1) { () -> Void in
            self.moneyBag.alpha = 1
        }
        
        UIView.animateWithDuration(1.5) { () -> Void in
            self.moneyBag.alpha = 0
        }
        
    }
    
    // Save core data
    func saveItem(totalBill: String, billDate: String) {
        
        let managedContext = DataController().managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Purchased", inManagedObjectContext: managedContext)
        let item   = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        item.setValue(totalBill, forKey: "totalAmount")
        item.setValue(billDate,  forKey: "paidDate")
        
        do {
            try managedContext.save()
            listItems.append(item)
        } catch {
            print("Error")
        }
    }
    
    // Clear all characters in bill field
    @IBAction func clearBillField(sender: AnyObject) {
        billField.text = ""
        myArray.myBillField = billField.text! ?? ""
        cal_function()
    }
    
    
    
}

