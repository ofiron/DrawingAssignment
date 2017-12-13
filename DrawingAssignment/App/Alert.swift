//
//  Alert.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 19/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import UIKit

/// Centralized Alert mechanism
struct Alert {
    
    /// Show failure alert for Facade.FacadeError type
    ///
    /// - Parameters:
    ///   - error: error from Facade.FacadeError type
    ///   - viewController: the vc to present the alert on it
    func showFailureAlert(_ error: Facade.FacadeError, on viewController: UIViewController?) {
        let message: String
        switch error {
        case .loadDrawingFile:
            message = NSLocalizedString("alert.error.message.loadingFile", comment: "")
        case .saveDrawingFile:
            message = NSLocalizedString("alert.error.message.savingFile", comment: "")
        case .loadDrawingList:
            message = NSLocalizedString("alert.error.message.loadingList", comment: "")
        }
        showFailureAlert(message, on: viewController)
    }
    
     /// Show failure alert for message String
     ///
     /// - Parameters:
     ///   - message: String for the alert message
     ///   - viewController: the vc to present the alert on it
     func showFailureAlert(_ message: String, on viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        let errorTitleText = NSLocalizedString("alert.error.title", comment: "")
        let okText = NSLocalizedString("alert.ok", comment: "")
        let alert = UIAlertController(title: errorTitleText, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: okText, style: .default, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// Show success alert for message string
    ///
    /// - Parameters:
    ///   - message: String for the alert message
    ///   - viewController: the vc to present the alert on it
    func showSuccessAlert(_ message: String, on viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        let okText = NSLocalizedString("alert.ok", comment: "")
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: okText, style: .default, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }

}
