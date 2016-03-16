//
//  OrdersTVC.swift
//  
//
//  Created by atMamont on 13.03.16.
//
//

import UIKit

class OrdersTVC: UITableViewController {

    var df: NSDateFormatter =  NSDateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        df.dateStyle = .ShortStyle
        df.timeStyle = .NoStyle
        
        view.backgroundColor = UI.catskillWhite

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Model.sharedInstance.orders.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderCell", forIndexPath: indexPath) as! OrderTableViewCell

        let o = Model.sharedInstance.orders[indexPath.row]
        cell.sumLabel.text = String(o.sum) + NSLocalizedString(" uah", comment: "Currency")
        cell.statusLabel.text = NSLocalizedString("Status: ", comment: "") + o.status
        cell.dateLabel.text = df.stringFromDate(o.creationDate)
        cell.photoFormat.text = NSLocalizedString("Size: ", comment: "") + o.photoFormat.description
        cell.photosCount.text = NSLocalizedString("Selected photos: ", comment: "") + String(o.photos.count)

        cell.layer.cornerRadius = CGFloat(10.0)
        cell.clipsToBounds = true;
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UI.catskillWhite.CGColor
//        cell.layer.backgroundColor = UI.catskillWhite.CGColor
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if Model.sharedInstance.orders[indexPath.row] == Model.sharedInstance.currentOrder {
                Model.sharedInstance.currentOrder = nil
            }
            Model.sharedInstance.orders.removeAtIndex(indexPath.row)
            Model.sharedInstance.saveData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is OrderTableViewCell {
            let vc = segue.destinationViewController as?OrderViewController
            let indexPath = tableView.indexPathForCell(sender as! OrderTableViewCell)!
            vc?.order = Model.sharedInstance.orders[indexPath.row]
        }
    }

}
