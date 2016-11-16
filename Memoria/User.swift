//
//  User.swift
//  Memoria
//
//  Created by Matan Cohen on 16/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    let email: String
    let uid: String
    
    init(fIRUser: FIRUser) {
        self.email = fIRUser.email!
        self.uid = fIRUser.uid
    }
}
