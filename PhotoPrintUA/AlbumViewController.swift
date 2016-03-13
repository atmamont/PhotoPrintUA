//
//  AlbumViewController.swift
//  PhotoPrintUA
//
//  Created by atMamont on 21.02.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var albumTitle: UITextField!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    var album: Album = Album()
    var selectionMode = false
    var selectedItems: [AlbumItem] = []
    
    
    // MARK: - View Controller
    func updateUI(){
        self.title = album.title
        albumTitle.text = album.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

    }
    
    @IBAction func addPhotos(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController.init(title: "Add new photo", message: "", preferredStyle: .ActionSheet)
        
        let selectPhotoAction = UIAlertAction(title: "Photo library", style: .Default) {

            (action: UIAlertAction!) -> Void in
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .PhotoLibrary
//            picker.navigationBar.tintColor = .redColor()
            
            self.presentViewController(picker, animated:true, completion:nil)
        }
        
        
        let takePhotoAction = UIAlertAction(title: "Camera", style: .Default) {
            
            (action: UIAlertAction!) -> Void in
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .Camera
//            picker.navigationBar.tintColor = .redColor()
            
            self.presentViewController(picker, animated:true, completion:nil)
        }

        
        let selectCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            alertController.addAction(takePhotoAction)
        }
        alertController.addAction(selectPhotoAction)
        alertController.addAction(selectCancel)
        
        self.presentViewController(alertController, animated:true, completion:nil)
       
    }
    
    @IBAction func selectButtonTapped(sender: UIBarButtonItem) {
        if !selectionMode {
            selectionMode = true
            collectionView.allowsMultipleSelection = true
            
            if let _ = Model.sharedInstance.currentOrder {
                selectButton.title = NSLocalizedString("Add to order", comment: "")
                
            }else{
                selectButton.title = NSLocalizedString("Create order",comment: "")
                
            }
            selectButton.style = .Done
        }else{
            selectionMode = false
            collectionView.allowsMultipleSelection = false
            
            // creating new order if none active
            var currentOrder: Order!
            if let order = Model.sharedInstance.currentOrder {
                currentOrder = order
                print("Adding to existing order")
            } else {
                currentOrder = Order()
                Model.sharedInstance.currentOrder = currentOrder
                print("Creating new order")
            }
            
            print("Adding %d items",selectedItems.count)
            // adding selected photos to order
            for item in selectedItems {
                currentOrder.photos.append(item)
            }
            Model.sharedInstance.saveData()

            // clearing visible selection and temp array of selected photos
            selectedItems.removeAll()
            for indexpath in collectionView.indexPathsForSelectedItems()! {
                collectionView.deselectItemAtIndexPath(indexpath, animated: true)
            }
            
            selectButton.title = "Select photos"
            selectButton.style = .Plain
        }
    }

//     MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === doneButton {
            album.title = albumTitle.text!
        }
    }
    
    // MARK: - Collection View
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.photosCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("albumItemCell", forIndexPath: indexPath) as! AlbumItemCollectionViewCell
        cell.imageView.image = album.items[indexPath.item].getImage()
        cell.selectedBackgroundView = UIImageView(image: UIImage(named: "photo-frame-selected"))
        return cell
    }
    
    // always three photos in a row
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake((UIScreen.mainScreen().bounds.width-15)/4,120); //use height whatever you wants.
        return CGSizeMake(collectionView.bounds.width/3-5, collectionView.bounds.width/3-5)

    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard selectionMode else{
            return
        }
        let selectedItem = album.items[indexPath.row]
        selectedItems.append(selectedItem)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        guard selectionMode else {
            return
        }
        let deSelectedItem = album.items[indexPath.row]
        if let index = selectedItems.indexOf(deSelectedItem) {
            selectedItems.removeAtIndex(index)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
            return selectionMode
    }
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - Image Picker Delegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil	)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        
        if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            
            let newImage = possibleImage

            let imageName = NSUUID().UUIDString
            let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
                if let jpegData = UIImageJPEGRepresentation(newImage, 80) {
                    jpegData.writeToFile(imagePath, atomically: true)
                }
                
                // append items to model
                self.album.items.append(AlbumItem(filepath: imageName))

                // back to UI
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView.reloadData()
                })
            })
        }
        
        imagePickerControllerDidCancel(picker)
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        print("Documents dir: "+documentsDirectory)
        return documentsDirectory
    }

}
