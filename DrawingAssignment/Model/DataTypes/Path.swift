//
//  Path.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 13/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import UIKit

/// Storing a path of drawing
final class Path: Codable {
    
    enum CodingKeys: String, CodingKey {
        case color
        case width
        case points
        case painting
    }

    // MARK: - Variables
    
    /// Color of the path
    var color: UIColor
    /// The width of the line of the path
    var width: CGFloat
    /// Is in painting mode or erase
    var isPainting = true
    /// Holding the path's points
    private var points = [CGPoint]()
    
    // MARK: - Class Constructors and Codable
    
    /// Init function
    ///
    /// - Parameters:
    ///   - color: color of the path
    ///   - width: the lines width of the path
    ///   - isPainting: is it painting or erasing
    init(_ color: UIColor, with width: CGFloat, isPainting: Bool) {
        self.color = color
        self.width = width
        self.isPainting = isPainting
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        width = try values.decode(CGFloat.self, forKey: .width)
        let hexColorString = try values.decode(String.self, forKey: .color)
        color = UIColor(hexString: hexColorString)
        points = try values.decode([CGPoint].self, forKey: .points)
        isPainting = try values.decode(Bool.self, forKey: .painting)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(width, forKey: .width)
        try container.encode(color.toHexString(), forKey: .color)
        try container.encode(points, forKey: .points)
        try container.encode(isPainting, forKey: .painting)
    }

    // MARK: - Points
    
    /// Add point to the path
    ///
    /// - Parameter point: point to add to the path
    func add(_ point: CGPoint) {
        points.append(point)
    }
    
    /// Get all the points of the path
    ///
    /// - Returns: all the points of the path
    func getPoints() -> [CGPoint] {
        return points
    }
    
}
