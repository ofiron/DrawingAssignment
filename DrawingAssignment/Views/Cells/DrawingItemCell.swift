//
//  DrawingItemCell.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 14/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import UIKit

final class DrawingItemCell: UITableViewCell {

    // MARK: - Outlets
    
    /// The thumbnail image
    @IBOutlet weak var thumbnailImageView: UIImageView!
    /// The label for the creating date of the drawing
    @IBOutlet weak var createDateLabel: UILabel!
    /// The label for the last edit date of the drawing
    @IBOutlet weak var editDateLabel: UILabel!
    
    // MARK: - Class Constructors
    
    class func nib() -> UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: "DrawingItemCell", bundle: bundle)
    }
    
}
