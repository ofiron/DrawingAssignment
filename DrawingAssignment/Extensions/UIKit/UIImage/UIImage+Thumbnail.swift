//
//  UIImage+Thumbnail.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 17/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import UIKit

extension UIImage {
    
    // source: https://stackoverflow.com/questions/40675640/creating-a-thumbnail-from-uiimage-using-cgimagesourcecreatethumbnailatindex
    
    /// Create thumbnail for image
    ///
    /// - Parameter pixelSize: the max size of the thumbnail
    /// - Returns: thumbnail image of the instance
    func thumbnail(_ pixelSize: Int) -> UIImage {
        guard let imageData = UIImagePNGRepresentation(self) else {
            //TODO: add logger
            return UIImage()
        }
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: pixelSize] as CFDictionary
        let source = CGImageSourceCreateWithData(imageData as CFData, nil)!
        let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
        let thumbnail = UIImage(cgImage: imageReference)
        return thumbnail
    }
}
