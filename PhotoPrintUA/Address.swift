//
//  GenericAddress.swift
//  PhotoPrintUA
//
//  Created by atMamont on 21.02.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

class Address: NSObject, NSCoding {
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    
    override init(){
        super.init()
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
        self.firstName = aDecoder.decodeObjectForKey("firstName") as! String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as! String
        self.phone = aDecoder.decodeObjectForKey("phone") as! String
       
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(firstName, forKey: "firstName")
        aCoder.encodeObject(lastName, forKey: "lastName")
        aCoder.encodeObject(phone, forKey: "phone")

    }
}
