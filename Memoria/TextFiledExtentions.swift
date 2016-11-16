//
//  TextFiledExtentions.swift
//  Memoria
//
//  Created by Matan Cohen on 16/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func disableAutoCurrection() {
        self.autocorrectionType = UITextAutocorrectionType.no
    }
    
    func passwordFiled() {
        self.isSecureTextEntry = true
    }
    
    func emailFiled() {
        self.autocapitalizationType = UITextAutocapitalizationType.none
        self.keyboardType = UIKeyboardType.emailAddress
    }
}
