//
//  Model.swift
//  PhotoPrintUA
//
//  Created by atMamont on 30.01.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import UIKit

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
    }
    
    func loadData() {
        albums = loadAlbums()
        orders = loadOrders()
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

    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let albumsArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("albums")
    static let ordersArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("orders")
    
}

