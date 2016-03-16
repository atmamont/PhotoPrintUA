//
//  Address.swift
//  PhotoPrintUA
//
//  Created by atMamont on 20.02.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class PostalAddress: Address {
    var zip: UInt = 0
    var country: String = ""
    var city: String = ""
    var street: String = ""
    
    override var description: String {
        var a = ""
        
        if city.characters.count>0 {
            a += city
        }
        if street.characters.count>0 {
            if a.characters.count > 0 {
                a += ", "
            }
            a += street
        }
        return a
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
        self.zip = UInt(aDecoder.decodeIntForKey("zip"))
        self.country = aDecoder.decodeObjectForKey("country") as! String
        self.city = aDecoder.decodeObjectForKey("city") as! String
        self.street = aDecoder.decodeObjectForKey("street") as! String
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeInteger(Int(zip), forKey: "zip")
        aCoder.encodeObject(country, forKey: "country")
        aCoder.encodeObject(city, forKey: "city")
        aCoder.encodeObject(street, forKey: "street")
    }
}
