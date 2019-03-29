//
//  StringExtension.swift
//  Crush
//
//  Created by Ruhsane Sawut on 3/28/19.
//  Copyright © 2019 Ruhsane Sawut. All rights reserved.
//

import Foundation

extension String {
    
    var readOnlyNumber: String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
}
