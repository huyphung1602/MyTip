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
    
    @IBOutlet weak var background_setting: UIImageView!
    
    // Static texts variables
    @IBOutlet weak var perTitle: UILabel!
    
    @IBOutlet weak var ratio1: UILabel!
    @IBOutlet weak var ratio2: UILabel!
    @IBOutlet weak var ratio3: UILabel!
    
    @IBOutlet weak var themeTitle: UILabel!
    
    // Warning label
    @IBOutlet weak var warningLabel: UILabel!
    
    // Warning condition
    var condition_1 = 0
    var condition_2 = 0
    var condition_3 = 0
    var condition_flag = 0
    
    struct themeFlag {
        static var flag   = 1
    }
    
    struct configArray {
        static var configPercentages = [18, 20, 25]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load NSU
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Load array percentages
        // Load current value
        let current_value_1 = Int(ViewController.myArray.myPercentages[0] * 100)
        let current_value_2 = Int(ViewController.myArray.myPercentages[1] * 100)
        let current_value_3 = Int(ViewController.myArray.myPercentages[2] * 100)
        configArray.configPercentages = [current_value_1, current_value_2, current_value_3]
        
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
        
        let checkNil = defaults.objectForKey("theme_flag")
        
        if checkNil != nil {
        themeFlag.flag = Int(defaults.objectForKey("theme_flag") as! NSNumber)
            if (themeFlag.flag == 0) {
                set_bg_setting_1()
            } else {
                set_bg_setting_2()
            }
        }
        
        warningLabel.text = ""
        
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
       
       // Use to warning if users input is not integer
       if ((Int(userField1.text!) == nil) && (userField1.text != "")) {
           userField1.text = ""
           condition_1 = 1
       }
       
       if ((Int(userField2.text!) == nil) && (userField2.text != "")) {
           userField2.text = ""
           condition_2 = 1
       }
        
       if ((Int(userField3.text!) == nil) && (userField3.text != "")) {
           userField3.text = ""
           condition_3 = 1
       }
        
       condition_flag = condition_1 + condition_2 + condition_3
       
       if (condition_flag != 0) {
           warningLabel.text = "Ratio must be integer"
       } else {
           warningLabel.text = ""
       }
        
       // Catch the values from keyboard
       let config_1  = Int(userField1.text!) ?? configArray.configPercentages[0]
       let config_2  = Int(userField2.text!) ?? configArray.configPercentages[1]
       let config_3  = Int(userField3.text!) ?? configArray.configPercentages[2]
       
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
        
       // Save key for flags
       defaults.setInteger(1, forKey: "save_flag")
       defaults.synchronize()
        
       configArray.configPercentages = [config_1, config_2, config_3]
       condition_1 = 0
       condition_2 = 0
       condition_3 = 0
       condition_flag = 0
        
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
    
    @IBAction func changeTheme(sender: AnyObject) {

        
        // Switch theme
        if (themeFlag.flag == 1) {
            set_bg_setting_1()
            themeFlag.flag = 0
            
        } else {
            set_bg_setting_2()
            themeFlag.flag = 1
            
        }
        
        // Save flag
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(themeFlag.flag, forKey: "theme_flag")
        defaults.synchronize()
        
    }
    
    func set_bg_setting_1() {
        background_setting.image = image1
        
        perTitle.textColor    = myBlack
        themeTitle.textColor  = myBlack
        
        ratio1.textColor      = myBlack
        ratio2.textColor      = myBlack
        ratio3.textColor      = myBlack
        
        perLabel1.textColor   = myRed
        perLabel2.textColor   = myRed
        perLabel3.textColor   = myRed
    }
    
    func set_bg_setting_2() {
        background_setting.image = image2
        
        perTitle.textColor    = myOrange
        themeTitle.textColor  = myOrange
        
        ratio1.textColor      = myWhite
        ratio2.textColor      = myWhite
        ratio3.textColor      = myWhite
        
        perLabel1.textColor   = myOrange
        perLabel2.textColor   = myOrange
        perLabel3.textColor   = myOrange
    }
    
    // Function make user cannot input "000..."
    @IBAction func userField1Changed(sender: AnyObject) {
        // Do not let user input "00000.."
        if (userField1.text == "00") {
            userField1.text = "0"
        }
    }
    
    @IBAction func userField2Changed(sender: AnyObject) {
        // Do not let user input "00000.."
        if (userField2.text == "00") {
            userField2.text = "0"
        }
    }
    
    @IBAction func userField3Changed(sender: AnyObject) {
        // Do not let user input "00000.."
        if (userField3.text == "00") {
            userField3.text = "0"
        }
    }
    
}
