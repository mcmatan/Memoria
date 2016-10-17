//
//  UIViewExntentions.swift
//  Memoria
//
//  Created by Matan Cohen on 17/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var width: CGFloat  {
        get {
         return self.frame.size.width
        }
    }
    var height: CGFloat  {
        get {
            return self.frame.size.height
        }
    }
    var centerX: CGFloat  {
        get {
            return self.frame.size.width / 2
        }
    }
    var centerY: CGFloat  {
        get {
            return self.frame.size.height / 2
        }
    }
    var bottom: CGFloat  {
        get {
            return self.frame.size.height + self.frame.origin.x
        }
    }
}
