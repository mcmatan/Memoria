//
//  ApplicationExntentions.swift
//  Memoria
//
//  Created by Matan Cohen on 08/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    static func isInBackground()-> Bool {
        let state: UIApplicationState = UIApplication.shared.applicationState // or use  let state =
        if state == .background {
            return true
        }else {
            return false
        }
    }
    
    static func isActive()-> Bool {
        let state: UIApplicationState = UIApplication.shared.applicationState // or use  let state =
        if state == .active {
            return true
        }else {
            return false
        }
    }
}
