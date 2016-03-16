//
//  AlbumViewController.swift
//  PhotoPrintUA
//
//  Created by atMamont on 21.02.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var albumTitle: UITextField!
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
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
        
        collectionView.backgroundColor = UI.catskillWhite
        view.backgroundColor = UI.navy
        bottomBar.barTintColor = UI.navy
        bottomBar.tintColor = UIColor.whiteColor()
        bottomBar.backgroundColor = UI.catskillWhite
        
        cancelButton.enabled = false
    }
    
    @IBAction func addPhotos(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController.init(title: NSLocalizedString("Add new photo", comment: "Alert title"), message: "", preferredStyle: .ActionSheet)
        
        let selectPhotoAction = UIAlertAction(title: NSLocalizedString("Photo library", comment: ""), style: .Default) {

            (action: UIAlertAction!) -> Void in
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .PhotoLibrary
//            picker.navigationBar.tintColor = .redColor()
            
            self.presentViewController(picker, animated:true, completion:nil)
        }
        
        
        let takePhotoAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .Default) {
            
            (action: UIAlertAction!) -> Void in
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .Camera
//            picker.navigationBar.tintColor = .redColor()
            
            self.presentViewController(picker, animated:true, completion:nil)
        }

        
        let selectCancel = UIAlertAction(title: NSLocalizedString("Cancel", comment:""), style: .Cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            alertController.addAction(takePhotoAction)
        }
        alertController.addAction(selectPhotoAction)
        alertController.addAction(selectCancel)
        
        self.presentViewController(alertController, animated:true, completion:nil)
       
    }
    
    func setSelectButtonTitle(){
        if let _ = Model.sharedInstance.currentOrder {
        selectButton.title = String(format: NSLocalizedString("Add to order (%d)", comment: ""), selectedItems.count)
        }else{
        selectButton.title = String(format: NSLocalizedString("New order (%d)", comment: ""), selectedItems.count)
        }
    }
    
    @IBAction func selectButtonTapped(sender: UIBarButtonItem) {
        if !selectionMode {
            selectionMode = true
            collectionView.allowsMultipleSelection = true
            
            setSelectButtonTitle()
            selectButton.style = .Done
            
            if selectedItems.count > 0 {
                cancelButton.enabled = true
            }
        }else{
            selectionMode = false
            collectionView.allowsMultipleSelection = false

            if selectedItems.count > 0 {

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
                
                performSegueWithIdentifier("showOrder", sender: self)
            }
            clearSelection()
        }
    }

    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        clearSelection()
        selectionMode = false
    }
    
    func clearSelection(){
        // clearing visible selection and temp array of selected photos
        selectedItems.removeAll()
        for indexpath in collectionView.indexPathsForSelectedItems()! {
            collectionView.deselectItemAtIndexPath(indexpath, animated: true)
        }
        selectButton.title = NSLocalizedString("Select", comment: "Select photos button")
        selectButton.style = .Plain
        
    }
//     MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === doneButton {
            album.title = albumTitle.text!
        }
        
        if sender === self { // finished order editing
            let vc = segue.destinationViewController as! OrderViewController
            vc.order = Model.sharedInstance.currentOrder
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
    
    // resize cells - always three photos in a row
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((collectionView.bounds.width)/3, (collectionView.bounds.width)/3)

    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard selectionMode else{
            return
        }
        let selectedItem = album.items[indexPath.row]
        selectedItems.append(selectedItem)
        if selectedItems.count > 0 {
            cancelButton.enabled = true
        }
        setSelectButtonTitle()

    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        guard selectionMode else {
            return
        }
        let deSelectedItem = album.items[indexPath.row]
        if let index = selectedItems.indexOf(deSelectedItem) {
            selectedItems.removeAtIndex(index)
        }
        if selectedItems.count > 0 {
            cancelButton.enabled = true
        }
        setSelectButtonTitle()

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
