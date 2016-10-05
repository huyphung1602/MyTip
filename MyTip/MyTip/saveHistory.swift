//
//  saveHistory.swift
//  MyTip
//
//  Created by Quoc Huy on 10/3/16.
//  Copyright © 2016 Quoc Huy. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class saveHistory: UITableViewController {
    
    // Delete rows variable
    var deleteHistoryIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addItem"))
        
        // Apply current seletected theme
        let defaults = NSUserDefaults.standardUserDefaults()
        let checkNil = defaults.objectForKey("theme_flag")
        
        if checkNil != nil {
            let themeFlag = Int(defaults.objectForKey("theme_flag") as! NSNumber)
            if (themeFlag == 0) {
                self.tableView.backgroundView = UIImageView(image: image1)
            } else {
                self.tableView.backgroundView = UIImageView(image: image2)
            }
        } else {
                self.tableView.backgroundView = UIImageView(image: image2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        fetchCoreData()
        
        self.tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        fetchCoreData()

        let item = listItems[indexPath.row]
        
        let myTotalAmount = item.valueForKey("totalAmount") as! String
        let myDate        = item.valueForKey("paidDate") as! String
        
        cell.textLabel!.numberOfLines = 3
        cell.textLabel!.lineBreakMode  = NSLineBreakMode.ByWordWrapping
        
        cell.textLabel?.text = String(format: "%@\nPaid: %@\n", myDate, myTotalAmount)
        
        return cell
    }
    
    // Function used to delete the history cell by swipe on the screen
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteHistoryIndexPath = indexPath
            confirmDelete()
        }
    }
    
    // Function used to draw the alert board on the screen after swipe delete perform
    func confirmDelete() {
        let alert = UIAlertController(title: "Delete this paymennt", message: "Are you sure you want to permanently delete this payment?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteHistory)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteHistory)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    
    }
    
    // Function used to handle the delete action
    func handleDeleteHistory(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteHistoryIndexPath {
            fetchCoreData()
            tableView.beginUpdates()
            
            listItems.removeAtIndex(indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            let managedContext = DataController().managedObjectContext
            
            let purchasedFetch = NSFetchRequest(entityName: "Purchased")
            do {
                
                var results = try managedContext.executeFetchRequest(purchasedFetch) as! [Purchased]
                //listItems = results as! [NSManagedObject]
                
                managedContext.deleteObject(results[indexPath.row])
                
                for var i = indexPath.row; i <= results.count - 2; i += 1 {
                    results[i] = results[i+1]
                }
                
                try!managedContext.save()
                
            } catch {
                print("Error")
            }
            
            deleteHistoryIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    // Function used to handle cancel action
    func cancelDeleteHistory(alertAction: UIAlertAction!) {
        deleteHistoryIndexPath = nil
    }
    
    func fetchCoreData () {
        
        let managedContext = DataController().managedObjectContext
        
        let purchasedFetch = NSFetchRequest(entityName: "Purchased")
        
        do {
            let results = try managedContext.executeFetchRequest(purchasedFetch)
            listItems = results as! [NSManagedObject]
        } catch {
            print("Error")
        }
        
    }
    
    // Function use to clear all the history
    @IBAction func clearAllHistory(sender: AnyObject) {
        
        //This function is used to removed all the data in history screen
        let managedContext = DataController().managedObjectContext
        
        let purchasedFetch = NSFetchRequest(entityName: "Purchased")
        do {
            
            let results = try managedContext.executeFetchRequest(purchasedFetch) as! [Purchased]
            //listItems = results as! [NSManagedObject]
            
            for var i = 0; i <= results.count - 1; i += 1 {
                managedContext.deleteObject(results[i])
            }
            
            try!managedContext.save()
            
        } catch {
            print("Error")
        }
        
        fetchCoreData()
        
        self.tableView.reloadData()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


}
