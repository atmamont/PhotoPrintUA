//
//  Formats.swift
//  PhotoPrintUA
//
//  Created by atMamont on 11.03.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

import Foundation

enum PhotoFormat: Int {
    case f9x12 = 0, f10x18, f18x23, f20x30, Count
    
    static var count: Int {
        return self.Count.rawValue
    }
    
    var description: String {
        switch self{
        case .f9x12: return "9x12"
        case .f10x18: return "10x18"
        case .f18x23: return "18x23"
        case .f20x30: return "20x30"
        default:
            return "other"
        }
    }
}