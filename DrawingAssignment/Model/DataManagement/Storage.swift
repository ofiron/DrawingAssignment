//
//  Storage.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 17/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import Foundation

/// Wrapper for storing and retrieving data from the drive
struct Storage {
    
    /// Save data to file
    ///
    /// - Parameters:
    ///   - data: Data to store in the drive
    ///   - name: the file name for storing the data
    ///   - type: the extenstion type of the file
    /// - Returns: Bool if success to save the data in the file
    func save(_ data: Data, file name: String, extension type: String) -> Bool {
        let url = getStorageDirectory().appendingPathComponent(name).appendingPathExtension(type)
        do {
            try data.write(to: url)
            return true
        } catch {
            return false
        }
    }
    
    /// The function load data from file
    ///
    /// - Parameters:
    ///   - name: the file name
    ///   - type: teh file extenstion
    /// - Returns: Data of the file, nil If not existed
    /// - Throws: Error
    func load(file name: String, extension type: String) throws -> Data? {
        let url = getStorageDirectory().appendingPathComponent(name).appendingPathExtension(type)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            let nsError = error as NSError
            if nsError.domain == NSCocoaErrorDomain, nsError.code ==  NSFileReadNoSuchFileError {
                return nil
            }
            throw error
        }
    }
    
}

private extension Storage {
    
    /// Get the directory storing and retrieving data from drive
    ///
    /// - Returns: The base directory for the storage to use
    private func getStorageDirectory() -> URL {
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
        
        return getDocumentsDirectory()
    }
    
}
