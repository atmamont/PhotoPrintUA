//
//  Album.swift
//  PhotoPrintUA
//
//  Created by atMamont on 20.02.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class Album: NSObject, NSCoding {
    
    var title: String = ""
    var items = [AlbumItem]()

    // calculated property
    var photosCount: Int {
        get {
            return items.count
        }
        // no setter
    }
    
    
    override init() {
        title = ""

        super.init()
        
    }
    
    func addItem(item: AlbumItem){
        items.append(item)
    }
    
    func removeItem(item: AlbumItem){
        if let index = items.indexOf(item) {
            items.removeAtIndex(index)
        }
    }
    
    // MARK: - NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.items = aDecoder.decodeObjectForKey("items") as! [AlbumItem]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(items, forKey: "items")
    }

}
