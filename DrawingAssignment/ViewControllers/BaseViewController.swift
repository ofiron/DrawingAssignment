//
//  BaseViewController.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 18/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Outlets
    
    /// View that hold the spinner views
    @IBOutlet private weak var holderOfSpinnerView: UIView?
    /// Activity indicator for the spinner
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
        
    // MARK: - Spinners
    
    /// Show spinner on the view controller
    func showSpinner() {
        guard let holderOfSpinnerView = holderOfSpinnerView else { return }
        holderOfSpinnerView.superview?.bringSubview(toFront: holderOfSpinnerView)
        holderOfSpinnerView.isHidden = false
        activityIndicatorView?.startAnimating()
    }
    
    /// Hide the spinner, and remove it from sight
    func hideSpinner() {
        guard let holderOfSpinnerView = holderOfSpinnerView else { return }
        holderOfSpinnerView.superview?.sendSubview(toBack: holderOfSpinnerView)
        holderOfSpinnerView.isHidden = true
        activityIndicatorView?.stopAnimating()
    }
    
}
