//
//  LogInService.swift
//  Memoria
//
//  Created by Matan Cohen on 16/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import FirebaseAuth

class LoginService {
    let fireBaseCoreWrapper: FireBaseCoreWrapper
    init(fireBaseCoreWrapper: FireBaseCoreWrapper) {
        self.fireBaseCoreWrapper = fireBaseCoreWrapper
    }
    
    func logIn(email: String, password: String, complation: @escaping (_ success: Bool, _ error: String?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let isError = error {
                complation(false, "Error = \(isError.localizedDescription)")
                print("Error at loggin = \(isError.localizedDescription)")
            } else {
                Bootstrapper.runMainApplication()
                complation(true, nil)
                print("Login success!")
            }
        }
    }
}
