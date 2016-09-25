//
//  ViewController.swift
//  MyTip
//
//  Created by Quoc Huy on 9/12/16.
//  Copyright © 2016 Huy Phung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    struct MyArray {
        static var myPercentages = [0.18, 0.20, 0.25]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("view did appear")
        // Load NSU
        let defaults = NSUserDefaults.standardUserDefaults()
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
            
            MyArray.myPercentages = [tipPercenttages_1, tipPercenttages_2, tipPercenttages_3]
            
            // Change the titles of the Segment
            tipControl.setTitle (segment_text_1, forSegmentAtIndex:0)
            tipControl.setTitle (segment_text_2, forSegmentAtIndex:1)
            tipControl.setTitle (segment_text_3, forSegmentAtIndex:2)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("view will disappear")
        
        // Store my array
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(Int(MyArray.myPercentages[0]*100), forKey: "MyArray_1")
        defaults.setInteger(Int(MyArray.myPercentages[1]*100), forKey: "MyArray_2")
        defaults.setInteger(Int(MyArray.myPercentages[2]*100), forKey: "MyArray_3")
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("view did disappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(sender: AnyObject) {
        
        var tipPercentages = MyArray.myPercentages
        
        let bill  = Double(billField.text!) ?? 0
        let tip   = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text   = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
    }
    
    
}

