//
//  DrawingView.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 13/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import UIKit

final class DrawingView: UIView {
    
    /// Error type that the instance can throw
    ///
    /// - exportingImage: failure to export the image
    enum DrawingError: Error {
        /// failure to export the image
        case exportingImage
    }
    
    // MARK: - Outlets

    // MARK: - Variables
    
    /// Current color of the line
    var color = UIColor.red
    /// Current width for a line
    var strokeWidth: CGFloat = 1
    /// Is in painting mode or erasing
    var isPainting = true
    /// The current touch that are drawing
    private var currentTouch: UITouch?
    /// All the paths of the drawing
    private var paths = [Path]()
    /// The current path that user use now
    private var currentPath: Path?
    /// Draw image where the paths of the drawing are presenting on the screen
    private weak var drawImage: UIImageView?
    
    // MARK: - Class Constructors
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitilization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitilization()
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard currentTouch == nil else { return }
        currentPath = Path(color, with: strokeWidth, isPainting: isPainting)
        currentTouch = touches.first
        guard let point = currentTouch?.location(in: self) else { return }
        currentPath?.add(point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentTouch = currentTouch else { return }
        guard touches.contains(currentTouch) else { return }
        let point = currentTouch.location(in: self)
        let previousPoint = currentPath?.getPoints().last ?? point
        currentPath?.add(point)
        guard let currentPath = currentPath else { return }
        drawing(currentPath, origin: previousPoint, destination: point)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentTouch = currentTouch else { return }
        guard let currentPath = currentPath else { return }
        guard touches.contains(currentTouch) else { return }
        
        let point = currentTouch.location(in: self)
        currentPath.add(point)
        self.currentTouch = nil
        paths.append(currentPath)
        self.currentPath = Path(color, with: strokeWidth, isPainting: isPainting)
    }

    // MARK: - Context Image
    
    /// Export the current drawing to UIImage
    ///
    /// - Returns: UIImage representation of the drawing
    /// - Throws: errors of DrawingError type may thrown out
    func image() throws -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            throw DrawingError.exportingImage
        }
        self.layer.render(in: context)
        guard let image =  UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            throw DrawingError.exportingImage
        }
        UIGraphicsEndImageContext()
        return image
    }

    // MARK: - Model Drawing
    
    /// Clear the drawing
    func clear() {
        currentPath = nil
        paths.removeAll()
        resetDrawImage()
    }
    
    /// Get the drawing model data
    ///
    /// - Returns: list of Paths of the drawing
    func getDrawingData() -> [Path] {
        return paths
    }
    
    /// Set the drawing with model data
    ///
    /// - Parameter data: list of paths for drawing
    func setDrawing(_ data: [Path]) {
        self.paths = data
        self.currentPath = nil
        for path in data {
            drawing(path)
        }
    }
    
}

// MARK: - Initialization
fileprivate extension DrawingView {
    
    /// Common initilization
    /// - note: this should be called from every init function
    fileprivate func commonInitilization() {
        resetDrawImage()
    }
    
    /// Reset the current draw image. Remove the current and adding a new one
    private func resetDrawImage() {
        self.drawImage?.removeFromSuperview()
        let drawImage = UIImageView()
        var rect = frame
        rect.origin = CGPoint.zero
        drawImage.frame = rect
        drawImage.backgroundColor = UIColor.clear
        self.drawImage = drawImage
        addSubview(subView: drawImage, fillEntireView: true)
    }
}

// MARK: - Drawing
private extension DrawingView {
    
    /// Drawing the a path
    ///
    /// - Parameter path: Path to draw
    private func drawing(_ path: Path) {
        let points = path.getPoints()
        guard points.count > 0 else { return }
        var previousPoint = points[0]
        for point in points {
            drawing(path, origin: previousPoint, destination: point)
            previousPoint = point
        }
    }
    
    /// Drawing points by using path
    ///
    /// - Parameters:
    ///   - path: Path of the drawing
    ///   - origin: first point to draw
    ///   - destination: second point to draw to it
    private func drawing(_ path: Path, origin: CGPoint, destination: CGPoint) {
        if path.isPainting {
            UIGraphicsBeginImageContext(self.frame.size)
            drawImage?.image?.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.setLineCap(.round)
            context.setLineWidth(path.width)
            context.setStrokeColor(path.color.cgColor)
            context.beginPath()
            context.move(to: origin)
            context.addLine(to: destination)
            context.strokePath()
            drawImage?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            drawImage?.image?.draw(in: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.setBlendMode(.clear)
            context.setLineCap(.round)
            context.setLineWidth(path.width)
            context.setStrokeColor(UIColor.clear.cgColor)
            context.beginPath()
            context.move(to: origin)
            context.addLine(to: destination)
            context.strokePath()
            drawImage?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }

}
