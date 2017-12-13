//
//  Facade.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 14/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import UIKit

/// Extension for storing data
fileprivate let saveExtension = "plist"
/// The file name for storing the drawings data
fileprivate let listFileName = "list"
/// Extension type for drawing image's thumbnail
fileprivate let thumbnailExtension = "png"

final class Facade {
    
    /// Errors that the Facade can send in the failure closers
    ///
    /// - loadDrawingFile: error while loading a drawing
    /// - saveDrawingFile: error while saving a drawing
    /// - loadDrawingList: error loading the list of drawings
    enum FacadeError: Error {
        /// error while loading a drawing
        case loadDrawingFile
        /// error while saving a drawing
        case saveDrawingFile
        /// error loading the list of drawings
        case loadDrawingList
    }
    
    // MARK: - Variables
    
    /// Shard instance
    internal static let shared = Facade()
    
    // MARK: - Drawing
    
    /// Load list of drawings
    ///
    /// - Parameters:
    ///   - success: success closure with list of drawingItem
    ///   - failure: failure closure
    func loadDrawings(success: @escaping ([DrawingItem])-> Void, failure: @escaping (FacadeError) -> Void) {
        do {
            let items = try loadDrawings()
            DispatchQueue.main.async {
                success(items)
            }
        } catch {
            DispatchQueue.main.async {
                failure(.loadDrawingList)
            }
        }
    }
    
    /// Saving a drawing
    ///
    /// - Parameters:
    ///   - drawingItem: the drawing item to save, if not exist it a new one
    ///   - data: the drawing model data
    ///   - ofDrawing: image of the drawing, from this it will create thumbnail
    ///   - date: the creating date of the drawing
    ///   - editDate: the last edit date (if not existed it mean it never been edit)
    ///   - success: success closure with the new or updated DrawingItem
    ///   - failure: failure closure
    func saveDrawing(_ drawingItem: DrawingItem?, drawing data: [Path], image ofDrawing: UIImage?, creating date: Date, last editDate: Date?, success: @escaping (DrawingItem)-> Void, failure: @escaping (FacadeError) -> Void) {
        let item: DrawingItem
        // Create DrawingItem if not exist
        if let drawingItem = drawingItem {
            item = DrawingItem(identifier: drawingItem.identifier, creatingDate: drawingItem.creatingDate, lastEditDate: editDate)
        } else {
            let identifier = generateIdentifier()
            item = DrawingItem(identifier:identifier, creatingDate: date, lastEditDate: editDate)
        }
        
        // Save drawing data
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        guard let saveData = try? encoder.encode(data) else {
            DispatchQueue.main.async {
                failure(.saveDrawingFile)
            }
            return
        }
        let storage = Storage()
        guard storage.save(saveData, file: item.identifier, extension: saveExtension) else {
            DispatchQueue.main.async {
                failure(.saveDrawingFile)
            }
            return
        }
        // Save image's thumbnail
        if let ofDrawing = ofDrawing {
            let thumbnail = ofDrawing.thumbnail(Consts.thumbnailSize)
            if let thumbnailData = UIImagePNGRepresentation(thumbnail) {
                _ = storage.save(thumbnailData, file: item.thumbnailImageName, extension: thumbnailExtension)
            }
        }
        
        // Load all DrawingItem list and add or replace the drawing in the list
        guard let allItems = try? loadDrawings() else {
            DispatchQueue.main.async {
                failure(.saveDrawingFile)
            }
            return
        }
        var items = allItems
        if let drawingItem = drawingItem {
            if let index = items.index(of: drawingItem) {
                items[index] = item
            } else {
                items.append(item)
            }
        } else {
            items.append(item)
        }
        
        // Save the update list of DrawingItem
        guard let listData = try? encoder.encode(items) else {
            DispatchQueue.main.async {
                failure(.saveDrawingFile)
            }
            return
        }
        guard storage.save(listData, file: listFileName, extension: saveExtension) else {
            DispatchQueue.main.async {
                failure(.saveDrawingFile)
            }
            return
        }
        DispatchQueue.main.async {
            success(item)
        }
    }
    
    /// Load drawing model data from DrawingItem
    ///
    /// - Parameters:
    ///   - drawingItem: The DrawingItem to get data for it
    ///   - success: success closure with the list of path of the drawing
    ///   - failure: failure closure
    func loadDrawing(from drawingItem: DrawingItem, success: @escaping ([Path])-> Void, failure: @escaping (FacadeError) -> Void) {
        let storage = Storage()
        guard let loadData = try? storage.load(file: drawingItem.identifier, extension: saveExtension) else {
            DispatchQueue.main.async {
                failure(.loadDrawingFile)
            }
            return
        }
        guard let data = loadData else {
            DispatchQueue.main.async {
                failure(.loadDrawingFile)
            }
            return
        }
        let decoder = PropertyListDecoder()
        do {
            let paths = try decoder.decode([Path].self, from: data)
            DispatchQueue.main.async {
                success(paths)
            }
        } catch {
            DispatchQueue.main.async {
                failure(.loadDrawingFile)
            }
        }
    }
    
    /// Get thumbnail image for DrawingItem from the drive
    ///
    /// - Parameter drawingItem: the drawing
    /// - Returns: thumbnail image of the drawingItem
    func getThumbnail(for drawingItem: DrawingItem) -> UIImage? {
        let storage = Storage()
        guard let loadedData = try? storage.load(file: drawingItem.thumbnailImageName, extension: thumbnailExtension), let data = loadedData else {
            return nil
        }
        return UIImage(data: data)
    }
    
}

// MARK: -
// MARK: - Private
// MARK: -

// MARK: -
private extension Facade {
    
    /// Generate unique identifier
    ///
    /// - Returns: unique identifier String
    private func generateIdentifier() -> String {
        let identifier = UUID().uuidString
        return identifier
    }
    
    /// Load drawings list
    ///
    /// - Returns: list of drawing
    /// - Throws: the error it may thorwn out of FacadeError type
    private func loadDrawings() throws -> [DrawingItem] {
        let storage = Storage()
        var data: Data
        do {
            guard let loadData = try storage.load(file: listFileName, extension: saveExtension) else {
                return []
            }
            data = loadData
        } catch {
            throw FacadeError.loadDrawingList
        }
        let decoder = PropertyListDecoder()
        do {
            let items = try decoder.decode([DrawingItem].self, from: data)
            return items
        } catch {
            throw FacadeError.loadDrawingList
        }
    }
}
