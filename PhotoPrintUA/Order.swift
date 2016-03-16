//
//  Order.swift
//  PhotoPrintUA
//
//  Created by atMamont on 20.02.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class Order: NSObject {
    var creationDate: NSDate!
    var address: Address?
    var photos: [AlbumItem] = []{
        didSet{
            calcPrice()
        }
    }
    var sum: Double = 0.0
    var status: String = NSLocalizedString("New", comment: "Default status of an order")
    var photoFormat: PhotoFormat = .f10x18 {
        didSet {
            calcPrice()
        }
    }
    var editable = true
    
    func calcPrice(){
        self.sum = PriceCalc(order: self).price
    }
//    var name: String {
//        if album.count>0 {
//            var n = ""
//            for a in album {
//                if n.characters.count>0 {
//                    n += ", "
//                }
//                n += a.title
//            }
//            return n
//        }else{
//            return NSLocalizedString("No albums selected", comment: "")
//        }
//    }
    
    override init(){
        creationDate = NSDate.init()
        super.init()
    }

    // MARK: - NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.creationDate = aDecoder.decodeObjectForKey("creationDate") as? NSDate
        self.address = aDecoder.decodeObjectForKey("address") as? Address
        self.photos = aDecoder.decodeObjectForKey("photos") as! [AlbumItem]
        self.sum = aDecoder.decodeDoubleForKey("sum")
        self.status = aDecoder.decodeObjectForKey("status") as! String
        self.photoFormat = PhotoFormat(rawValue: Int(aDecoder.decodeIntForKey("photoFormat")))!
        self.editable = aDecoder.decodeBoolForKey("editable")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(creationDate, forKey: "creationDate")
        aCoder.encodeObject(address, forKey: "address")
        aCoder.encodeObject(photos, forKey: "photos")
        aCoder.encodeDouble(sum, forKey: "sum")
        aCoder.encodeObject(status, forKey: "status")
        aCoder.encodeInt(Int32(photoFormat.rawValue), forKey: "photoFormat")
        aCoder.encodeBool(editable, forKey: "editable")
    }
}
