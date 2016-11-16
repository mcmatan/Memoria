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
    let currentUserContext: CurrentUserContext
    var isLoggedIn = false
    
    init(fireBaseCoreWrapper: FireBaseCoreWrapper, currentUserContext: CurrentUserContext) {
        self.currentUserContext = currentUserContext
        self.fireBaseCoreWrapper = fireBaseCoreWrapper
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
               self.setCurrentUser(user: user)
               self.startMainApplicationIfLoggedOut(fireBaseUser: user)
            } else {
                // No user is signed in.
            }
        }
    }
    
    func logIn(email: String, password: String, complation: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (fireBaseUser, error) in
            if let isError = error {
                complation(false, "Error = \(isError.localizedDescription)")
                print("Error at loggin = \(isError.localizedDescription)")
            } else {
                self.setCurrentUser(user: fireBaseUser!)
                self.startMainApplicationIfLoggedOut(fireBaseUser: fireBaseUser!)
                complation(true, nil)
                print("Login success!")
            }
        }
    }
    
    func setCurrentUser(user: FIRUser) {
        let user = User(fIRUser: user)
        self.currentUserContext.setCurrentUser(user: user)
        
    }
    
    func startMainApplicationIfLoggedOut(fireBaseUser: FIRUser) {
        if self.isLoggedIn == false {
            self.isLoggedIn = true
            Bootstrapper.runMainApplication()
            Events.shared.loginSuccess.emit(())
        }
    }
}
