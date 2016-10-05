//
//  FirstScreen.swift
//  MyTip
//
//  Created by Quoc Huy on 9/25/16.
//  Copyright © 2016 Huy Phung. All rights reserved.
//

import UIKit

class FirstScreen: UIViewController {

    @IBOutlet weak var background_firstview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply current seletected theme
        let defaults = NSUserDefaults.standardUserDefaults()
        let checkNil = defaults.objectForKey("theme_flag")
        
        if checkNil != nil {
            let themeFlag = Int(defaults.objectForKey("theme_flag") as! NSNumber)
            if (themeFlag == 0) {
                background_firstview.image = image1
            } else {
                background_firstview.image = image2
            }
        }
        // Do any additional setup after loading the view.
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

}
