//
//  LoadingSpinner.swift
//  Crush
//
//  Created by Ruhsane Sawut on 3/21/19.
//  Copyright © 2019 Ruhsane Sawut. All rights reserved.
//

import Foundation
import UIKit

public class Loading {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray) // Create the activity indicator


    public func loading(view: UIView) {
        view.addSubview(activityIndicator) // add it as a  subview
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5) // put in the middle
        activityIndicator.startAnimating() // Start animating

    }

    public func stop() {
        activityIndicator.stopAnimating() // On response stop animating
        activityIndicator.removeFromSuperview() // remove the view
    }

}
