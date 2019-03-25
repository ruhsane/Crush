//
//  UserDefaults+helpers.swift
//  Crush
//
//  Created by Ruhsane Sawut on 3/25/19.
//  Copyright © 2019 Ruhsane Sawut. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: "isLoggedIn")
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")
    }
}
