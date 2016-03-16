//
//  OrderPhotosVC.swift
//  PhotoPrintUA
//
//  Created by atMamont on 15.03.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class OrderPhotosVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

    var order: Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UI.catskillWhite
        view.backgroundColor = UI.navy
    }

    // MARK: - Collection
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("albumItemCell", forIndexPath: indexPath) as! AlbumItemCollectionViewCell
        cell.imageView.image = order.photos[indexPath.item].getImage()
        cell.selectedBackgroundView = UIImageView(image: UIImage(named: "photo-frame-selected"))
        return cell
    }
    
    // resize cells - always three photos in a row
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((collectionView.bounds.width)/3, (collectionView.bounds.width)/3)
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        guard selectionMode else{
//            return
//        }
//        let selectedItem = album.items[indexPath.row]
//        selectedItems.append(selectedItem)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        guard selectionMode else {
//            return
//        }
//        let deSelectedItem = album.items[indexPath.row]
//        if let index = selectedItems.indexOf(deSelectedItem) {
//            selectedItems.removeAtIndex(index)
//        }
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
//        return selectionMode
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
