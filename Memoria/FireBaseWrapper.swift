//
//  FireBase.swift
//  Memoria
//
//  Created by Matan Cohen on 11/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth

class FireBaseWrapper {
    
    init() {
        FIRApp.configure()
    }
    
    func logIn(email: String, password: String, complation: @escaping (_ success: Bool, _ error: String?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let isError = error {
                complation(false, "Error = \(isError.localizedDescription)")
                print("Error at loggin = \(isError.localizedDescription)")
            } else {
                complation(true, nil)
                print("Login success!")
            }
        }
    }
}
