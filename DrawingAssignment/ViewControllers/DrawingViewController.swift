//
//  DrawingViewController.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 13/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import UIKit

final class DrawingViewController: BaseViewController {

    // MARK: - Outlets
    
    /// The drawing canvas view
    @IBOutlet weak var canvasView: DrawingView!
    
    // MARK: - Variables
    
    /// The current drawing item, if it not existed it mean it is a new one
    var drawingItem: DrawingItem?
    /// The creating date of the drawing
    private var createDate = Date()
    /// The last edit date of the drawing
    private var editDate: Date?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.color = UIColor.black
        canvasView.strokeWidth = PencilWidth.normal.rawValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let drawingItem = drawingItem else { return }
        showSpinner()
        Facade.shared.loadDrawing(from: drawingItem, success: { [weak self] (data) in
            self?.createDate = drawingItem.creatingDate
            self?.editDate = drawingItem.lastEditDate ?? Date()
            self?.canvasView.setDrawing(data)
            self?.hideSpinner()
            }, failure: { [weak self] (error) in
                self?.hideSpinner()
                Alert().showFailureAlert(error, on: self)
        })
    }
    
    // MARK: - Actions
    
    @IBAction func clearPressed(_ sender: Any) {
        canvasView.clear()
    }
    
    @IBAction func colorPressed(_ sender: UIButton) {
        let alertTitle = NSLocalizedString("alert.selectColor.title", comment: "")
        let alertCancel = NSLocalizedString("alert.cancel", comment: "")
        let alertStyle: UIAlertControllerStyle
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertStyle = .alert
        } else {
            alertStyle = .actionSheet
        }
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: alertStyle)
        let cancelAction = UIAlertAction(title: alertCancel, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let colors: [(String, UIColor)] = [(NSLocalizedString("alert.selectColor.color.red", comment: ""), UIColor.red),
                                         (NSLocalizedString("alert.selectColor.color.green", comment: ""), UIColor.green),
                                         (NSLocalizedString("alert.selectColor.color.blue", comment: ""), UIColor.blue),
                                         (NSLocalizedString("alert.selectColor.color.black", comment: ""), UIColor.black),
                                         ]
        for color in colors {
            let action = UIAlertAction(title: color.0, style: .default) {[weak self, weak sender] (_) in
                self?.canvasView.color = color.1
                sender?.backgroundColor = color.1
            }
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func widthPressed(_ sender: Any) {
        let alertTitle = NSLocalizedString("alert.selectWidth.title", comment: "")
        let alertCancel = NSLocalizedString("alert.cancel", comment: "")
        let alertStyle: UIAlertControllerStyle
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertStyle = .alert
        } else {
            alertStyle = .actionSheet
        }
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: alertStyle)
        let cancelAction = UIAlertAction(title: alertCancel, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let widths: [(String, PencilWidth)] = [(NSLocalizedString("alert.selectWidth.width.small", comment: ""), PencilWidth.small),
                                               (NSLocalizedString("alert.selectWidth.width.normal", comment: ""), PencilWidth.normal),
                                               (NSLocalizedString("alert.selectWidth.width.big", comment: ""), PencilWidth.big),
                                               ]
        for width in widths {
            let action = UIAlertAction(title: width.0, style: .default) {[weak self] (_) in
                self?.canvasView.strokeWidth = width.1.rawValue
            }
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }

    @IBAction func paintModeChanged(_ sender: Any) {
        canvasView.isPainting = (!canvasView.isPainting)
    }
    
    @IBAction func saveCanvasPressed(_ sender: Any) {
        showSpinner()
        DispatchQueue.main.async { [weak self] in
            guard let drawingPaths = self?.canvasView.getDrawingData(), let canvasView = self?.canvasView, let createDate = self?.createDate else { return }
            
            var image: UIImage? = nil
            do {
                image = try? canvasView.image()
            }
            // update edit date
            if let _ = self?.editDate {
                self?.editDate = Date()
            }
            Facade.shared.saveDrawing(self?.drawingItem, drawing: drawingPaths, image: image, creating: createDate, last: self?.editDate, success: { [weak self] (drawingItem) in
                self?.editDate = Date()
                self?.drawingItem = drawingItem
                self?.hideSpinner()
                self?.showSuccessAlert(.savingCanvas)
                }, failure: { [weak self] (error) in
                    self?.hideSpinner()
                    Alert().showFailureAlert(error, on: self)
            })
        }
    }
    
    @IBAction func exportImageToDevicePressed(_ sender: Any) {
        showSpinner()
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            do {
                let image = try strongSelf.canvasView.image()
                UIImageWriteToSavedPhotosAlbum(image, strongSelf, #selector(DrawingViewController.savedImage(_:didFinishSavingWith:context:)), nil)
            } catch {
                self?.hideSpinner()
                self?.showFailureAlert(.exportImageToDevice)
            }
        }
    }
    
    // MARK: - Callback
    
    /// Callback for saving image in the camera roll (using UIImageWriteToSavedPhotosAlbum)
    ///
    /// - Parameters:
    ///   - image:
    ///   - error:
    ///   - info:
    @objc func savedImage(_ image: UIImage?, didFinishSavingWith error: NSError?, context info: Any ) {
        hideSpinner()
        guard let _ = error else {
            showSuccessAlert(.exportImageToDevice)
            return
        }
        showFailureAlert(.exportImageToDevice)
    }

}

// MARK: -
// MARK: - Private
// MARK: -

// MARK: - Alert
fileprivate extension DrawingViewController{
    
    /// Alert error type for user action
    ///
    /// - savingCanvas: saving the canvas
    /// - exportImageToDevice: export image to device
    fileprivate enum AlertErrorType {
        /// saving the canvas
        case savingCanvas
        /// export image to device
        case exportImageToDevice
    }
    
    /// Alert success type for user action
    ///
    /// - savingCanvas: saving the canvas
    /// - exportImageToDevice: export image to device
    fileprivate enum AlertSuccessType {
        /// saving the canvas
        case savingCanvas
        /// export image to device
        case exportImageToDevice
    }
    
    /// Show failure alert for DrawingViewController.AlertErrorType
    ///
    /// - Parameter error: error from the enum DrawingViewController.AlertErrorType
    fileprivate func showFailureAlert(_ error: AlertErrorType) {
        let message: String
        switch error {
        case .savingCanvas:
            message = NSLocalizedString("alert.error.message.savingCanvas", comment: "")
        case .exportImageToDevice:
            message = NSLocalizedString("alert.error.message.savingImage", comment: "")
            
        }
        Alert().showFailureAlert(message, on: self)
    }
    
    /// Show success alert message
    ///
    /// - Parameter type: the type of the success from AlertSuccessType enum
    fileprivate func showSuccessAlert(_ type: AlertSuccessType) {
        let message: String
        switch type {
        case .exportImageToDevice:
            message = NSLocalizedString("alert.success.message.savingImage", comment: "")
        case .savingCanvas:
            message = NSLocalizedString("alert.success.message.savingCanvas", comment: "")
        }
        Alert().showSuccessAlert(message, on: self)
    }
    
}
