//
//  PriceCalc.swift
//  PhotoPrintUA
//
//  Created by atMamont on 15.03.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import Foundation

extension PhotoFormat {
    func getPrice() -> Double {
        switch self {
        case .f9x12: return 1.2
        case .f10x18: return 1.6
        case .f18x23: return 2.3
        case .f20x30: return 3.3
        default: return 0
        }
    }
}

class PriceCalc {
    
    var price: Double {
        return order.photoFormat.getPrice() * Double(order.photos.count)
    }
    
    var order: Order
    
    init(order: Order) {
        self.order = order
    }
}
