//
//  AlbumsTableViewController.swift
//  PhotoPrintUA
//
//  Created by atMamont on 21.02.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.backgroundColor = UI.catskillWhite
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.sharedInstance.albums.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> AlbumsTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("albumCell", forIndexPath: indexPath) as! AlbumsTableViewCell

        let album = Model.sharedInstance.albums[indexPath.item]
        
        cell.albumNameLabel!.text = album.title
        cell.photosCountLabel!.text = NSLocalizedString("Photos: ",comment: "")+String(album.photosCount)
        if album.photosCount>0 {
            cell.img.image = album.items[0].getImage()
        }

        let roundFactor = 10.0
//        let roundFactor = cell.img.frame.size.width / 2
        cell.img.layer.cornerRadius = CGFloat(roundFactor)
        cell.img.clipsToBounds = true;
        cell.img.layer.borderWidth = 1.0
        cell.img.layer.borderColor = UI.regentStBlue.CGColor
        
//        cell.layer.backgroundColor = UI.catskillWhite.CGColor
        
        cell.albumNameLabel.textColor = UI.navy
        cell.photosCountLabel.textColor = UI.lightBlue

        cell.layer.cornerRadius = 10.0;
        cell.clipsToBounds = true
        cell.layer.borderWidth = 5.0;
        cell.layer.borderColor = UI.catskillWhite .CGColor
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
            do{
                try Model.sharedInstance.removeAlbum(indexPath.item) // with cleanup
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                Model.sharedInstance.saveData()
            }
            catch {
                print("Album photos are used in orders")
                let alert = UIAlertController(title: NSLocalizedString("Error", comment:"Alert controller title"), message: NSLocalizedString("Photos in this album are used in some orders", comment: "Alert message"), preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
//            Model.sharedInstance.albums.removeAtIndex(indexPath.item)
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destinationViewController as? AlbumViewController
        vc?.hidesBottomBarWhenPushed = true
        if segue.identifier == "openAlbum" {

            if let selectedCell = sender as? AlbumsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let selectedAlbum = Model.sharedInstance.albums[indexPath.row]
                vc?.album = selectedAlbum
            }
        }
    }
    
    @IBAction func unwindToAlbumsList(sender: UIStoryboardSegue) {
        if let sourceVC = sender.sourceViewController as? AlbumViewController  {
            let a = sourceVC.album
            if a.title != ""{
    //            let newIndexPath = NSIndexPath(forRow: Model.sharedInstance.albums.count, inSection: 0)
                if !Model.sharedInstance.albums.contains(a) {
                    Model.sharedInstance.albums.append(a)

                }
                Model.sharedInstance.saveData()
                tableView.reloadData()
            }
//            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
        
        print(sender)
    }

}
