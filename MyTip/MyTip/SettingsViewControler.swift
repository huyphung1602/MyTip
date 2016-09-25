//
//  SettingsViewControler.swift
//  MyTip
//
//  Created by Quoc Huy on 9/17/16.
//  Copyright © 2016 Huy Phung. All rights reserved.
//

import UIKit

class SettingsViewControler: UIViewController {

    @IBOutlet weak var perLabel1: UILabel!
    @IBOutlet weak var perLabel2: UILabel!
    @IBOutlet weak var perLabel3: UILabel!

    @IBOutlet weak var userField1: UITextField!
    @IBOutlet weak var userField2: UITextField!
    @IBOutlet weak var userField3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load NSU
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Check Flag
        let flag = defaults.objectForKey("save_flag")
        print("\(flag)")
        
        if flag == nil {
            // Do nothing
            // tipControl.setTitle ("huyphung", forSegmentAtIndex:0)
        } else {
            // Load User percentages texts
            let segment_text_1 = defaults.objectForKey("percent_1_text") as! String
            let segment_text_2 = defaults.objectForKey("percent_2_text") as! String
            let segment_text_3 = defaults.objectForKey("percent_3_text") as! String
            
            // Update the user percentages display
            perLabel1.text = segment_text_1
            perLabel2.text = segment_text_2
            perLabel3.text = segment_text_3
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

       @IBAction func saveConfig(sender: AnyObject) {
       
       // Load the NSU
       let defaults = NSUserDefaults.standardUserDefaults()
        
       // Load current value
       let current_value_1 = defaults.objectForKey("MyArray_1")
       let current_value_2 = defaults.objectForKey("MyArray_2")
       let current_value_3 = defaults.objectForKey("MyArray_3")
        
       // Catch the values from keyboard
       let config_1  = Int(userField1.text!) ?? Int(current_value_1 as! NSNumber)
       let config_2  = Int(userField2.text!) ?? Int(current_value_2 as! NSNumber)
       let config_3  = Int(userField3.text!) ?? Int(current_value_3 as! NSNumber)
       
       // Update the user percentages display
       perLabel1.text = String(format: "%d%%", config_1)
       perLabel2.text = String(format: "%d%%", config_2)
       perLabel3.text = String(format: "%d%%", config_3)
        
       // Store the user percentages to NSU
       defaults.setObject(perLabel1.text, forKey: "percent_1_text")
       defaults.setInteger(config_1, forKey: "percent_1_value")
       defaults.setObject(perLabel2.text, forKey: "percent_2_text")
       defaults.setInteger(config_2, forKey: "percent_2_value")
       defaults.setObject(perLabel3.text, forKey: "percent_3_text")
       defaults.setInteger(config_3, forKey: "percent_3_value")
       // Save key
       defaults.setInteger(1, forKey: "save_flag")
       defaults.synchronize()
    
    }
    
    @IBAction func ressetConfig(sender: AnyObject) {
        
        // Update the default percentages display
        perLabel1.text = "18%"
        perLabel2.text = "20%"
        perLabel3.text = "25%"
        
        // Reset the NSU to default values
        // Store the user percentages to NSU
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(perLabel1.text, forKey: "percent_1_text")
        defaults.setInteger(18, forKey: "percent_1_value")
        defaults.setObject(perLabel2.text, forKey: "percent_2_text")
        defaults.setInteger(20, forKey: "percent_2_value")
        defaults.setObject(perLabel3.text, forKey: "percent_3_text")
        defaults.setInteger(25, forKey: "percent_3_value")
        // Save key
        defaults.setInteger(1, forKey: "save_flag")
        defaults.synchronize()
        
    }
    
    @IBAction func endKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
}
