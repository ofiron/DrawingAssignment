//
//  Consts.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 19/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import UIKit

/// Constants holder
struct Consts {
    
    static let dateFormat = "dd-MM-yyyy HH:mm"
    
    struct CellIdentifiers {
        static let common = "cell"
    }
    
    struct Segues {
        static let edit = "edit"
    }
    
    static let thumbnailSize = 100
}

enum PencilWidth: CGFloat {
    case small = 1
    case normal = 5
    case big = 10
}
