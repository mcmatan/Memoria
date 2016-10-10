//
//  ApplicationExntentions.swift
//  Memoria
//
//  Created by Matan Cohen on 09/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    static func isApplicationActive()->Bool {
        return UIApplication.shared.applicationState == UIApplicationState.active
    }
}
