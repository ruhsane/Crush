//
//  PresentVC.swift
//  Crush
//
//  Created by Ruhsane Sawut on 3/20/19.
//  Copyright © 2019 Ruhsane Sawut. All rights reserved.
//

import Foundation
import UIKit

public func presentVC(sbName: String, identifier: String, fromVC: UIViewController) {
    let storyboard = UIStoryboard(name: sbName, bundle: nil)
    let toVC = storyboard.instantiateViewController(withIdentifier: identifier)
    fromVC.present(toVC,animated: true)
}
