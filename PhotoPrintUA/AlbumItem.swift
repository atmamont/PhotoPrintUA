//
//  AlbumItem.swift
//  PhotoPrintUA
//
//  Created by atMamont on 20.02.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class AlbumItem: NSObject, NSCoding {
    var caption: String = ""
    var date: NSDate = NSDate()
    var filepath: String = ""
    var image: UIImage?{
        get{
            guard filepath != "" else {return nil}
            
            print("Restoring image from file "+filepath)
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentsDirectory = paths[0] as NSString
            let fullpath = documentsDirectory.stringByAppendingPathComponent(filepath)
            print("Restoring image from file "+fullpath)
            if let img = UIImage(contentsOfFile: fullpath){
                return img
            }else {
                return nil
            }
        }
    }
    
    
    func getImage() -> UIImage? {
        return self.image
    }
    
    func cleanImage(){
        if filepath == "" { return }
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let fullpath = documentsDirectory.stringByAppendingPathComponent(filepath)
        
        do {
            let fileManager:NSFileManager = NSFileManager.defaultManager()
            try fileManager.removeItemAtPath(fullpath)
            print("Removed photo \(fullpath)")
        }
        catch let error as NSError{
            print(error.debugDescription)
        }
    }
    
    required convenience init(filepath: String){
        self.init()
        
        self.filepath = filepath
    }
    
    
    // MARK: - NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.caption = aDecoder.decodeObjectForKey("caption") as! String
        self.filepath = aDecoder.decodeObjectForKey("filepath") as! String
        self.date = aDecoder.decodeObjectForKey("date") as! NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(caption, forKey: "caption")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(filepath, forKey: "filepath")
    }
}
