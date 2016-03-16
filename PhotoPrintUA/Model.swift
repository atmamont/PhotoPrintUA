//
//  Model.swift
//  PhotoPrintUA
//
//  Created by atMamont on 30.01.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int) {
        
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
        
    }
    
}

class UI {
    
    static let gray = UIColor(hex: 0xCCCCCC)
    static let navy = UIColor(hex: 0x003366)
    static let yellowGreen = UIColor(hex: 0xCCCC99)
    
    static let orange  = UIColor(hex: 0xFF9900)
    static let darkBrown  = UIColor(hex: 0x333333)
    static let lightBrown  = UIColor(hex: 0x666666)
    
    static let green  = UIColor(hex: 0x097054)
    static let warmYellow  = UIColor(hex: 0xFFDE00)
    static let blue  = UIColor(hex: 0x6599FF)
    
    static let white  = UIColor(hex: 0xFFFFFF)
    
    static let lightBlue = UIColor(hex: 0x6D929B)
    static let regentStBlue	 = UIColor(hex: 0xACD1E9)
    static let blueGreen = UIColor(hex: 0xC1DAD6)
    static let catskillWhite = UIColor(hex: 0xF5FAFA)
    static let nomad = UIColor(hex: 0xB7AFA3)
    static let zombie = UIColor(hex: 0xE8D0A9)
    
    static let bsGreen = UIColor(hex: 0x51A351)
    
    
}

enum Errors: ErrorType {
    case PhotoSelectedInOrder(Order)
}

class Model: NSObject {
    class var sharedInstance: Model {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Model? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Model()
        }
        return Static.instance!
    }
    
    override init(){
        super.init()
        loadData()
    }
    
    // MARK: - properties
    
    var rememberUser: Bool = false
    dynamic var albums = [Album]()
    dynamic var orders = [Order]()
    dynamic var addresses = [Address]()
    var currentOrder: Order? {
        didSet {
            guard let o = currentOrder else {return}
            if !orders.contains(o) {
                orders.append(o)
            }
        }
    }
    
    // MARK: - Authorization - LATER
    
    func authorizeUser(email: String, password: String, rememberMe rememberUser: Bool) -> Bool {

        self.rememberUser = rememberUser
        return email == "atmamont@gmail.com" && password == "1"
        
    }
    
    // MARK: - Array manupulating with images cleanup
    
    func removeAlbum(index: Int) throws {
        let album = albums[index]

        // check if photos are in orders
        // exceptions handling test
        
        for i in album.items {
            for o in orders {
                if o.photos.contains( {$0.filepath == i.filepath} ) {
                    throw Errors.PhotoSelectedInOrder(o)
                }
            }
        }

        // cleaning photo files
        for i in album.items {
            i.cleanImage()
        }
        albums.removeAtIndex(index)
    }
    
    // MARK: - Data persist
    
    func saveData(){
        let isSuccessfullSaveAlbums = NSKeyedArchiver.archiveRootObject(albums, toFile: Model.albumsArchiveURL.path!)
        
        if !isSuccessfullSaveAlbums {
            print("Failed to save albums")
        }

        let isSuccessfullSaveOrders = NSKeyedArchiver.archiveRootObject(orders, toFile: Model.ordersArchiveURL.path!)
        
        if !isSuccessfullSaveOrders {
            print("Failed to save orders")
        }
        
        let isSuccessfullSaveAddresses = NSKeyedArchiver.archiveRootObject(addresses, toFile: Model.addressesArchiveURL.path!)
        
        if !isSuccessfullSaveAddresses {
            print("Failed to save addresses")
        }
    }
    
    func loadData() {
        albums = loadAlbums()
        orders = loadOrders()
        addresses = loadAddresses()
    }
    
    func loadAlbums() -> [Album]{
        if NSFileManager.defaultManager().fileExistsAtPath(Model.albumsArchiveURL.path!) {
            if let a = NSKeyedUnarchiver.unarchiveObjectWithFile(Model.albumsArchiveURL.path!) as? [Album] {
                return a
            }
            else{
                return [Album]()
            }
        }else{
            return [Album]()
        }
        
    }
    
    func loadOrders() -> [Order]{
        if NSFileManager.defaultManager().fileExistsAtPath(Model.ordersArchiveURL.path!) {
            if let a = NSKeyedUnarchiver.unarchiveObjectWithFile(Model.ordersArchiveURL.path!) as? [Order] {
                return a
            }
            else{
                return [Order]()
            }
        }else{
            return [Order]()
        }
        
    }

    func loadAddresses() -> [Address]{
        if NSFileManager.defaultManager().fileExistsAtPath(Model.addressesArchiveURL.path!) {
            if let a = NSKeyedUnarchiver.unarchiveObjectWithFile(Model.addressesArchiveURL.path!) as? [Address] {
                return a
            }
            else{
                return [Address]()
            }
        }else{
            return [Address]()
        }
        
    }

    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let albumsArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("albums")
    static let ordersArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("orders")
    static let addressesArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("addresses")
    
}

