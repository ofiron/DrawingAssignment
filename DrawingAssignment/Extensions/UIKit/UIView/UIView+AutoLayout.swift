//
//  UIView+AutoLayout.swift
//  DrawingAssignment
//
//  Created by Ofir Ron on 18/12/2017.
//  Copyright © 2017 Ofir Ron. All rights reserved.
//

import UIKit

///  The AutoLayout extension is an helper for autoLayout views
extension UIView {
    
    /// Adds a view to the end of the receiver’s list of subviews.
    /// @discussion This method set the view to fill the entire view with the subview, using auto layout constraint. The method use the addSubview functionality.
    /// - parameter subView:        The view to be added. After being added, this view appears on top of any other subviews.
    /// - parameter fillEntireView: Is to subview should fill all the view.
    public func addSubview(subView: UIView, fillEntireView: Bool) {
        guard fillEntireView == true else {
            addSubview(subView)
            return
        }
        subView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subView)
        addConstraint(NSLayoutConstraint(item: subView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
}
