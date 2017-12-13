//
//  DrawingItem.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 14/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import Foundation

/// Hold an drawing data
struct DrawingItem: Codable {
    
    /// id of the instance
    let identifier: String
    /// the filename for thumbnail image
    var thumbnailImageName: String {
        get {
            return identifier + "thumbnail"
        }
    }
    /// The create date for the drawing
    let creatingDate: Date
    /// The last update date, the drawing was edited
    let lastEditDate: Date?
}

extension DrawingItem: Equatable {
    
    static func ==(lhs: DrawingItem, rhs: DrawingItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
}
