//
//  CurrentUserContext.swift
//  Memoria
//
//  Created by Matan Cohen on 16/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class CurrentUserContext {
    private var user: User?
    
    func getCurrentUser()->User {
        if let isUser = self.user {
            return isUser
        } else {
            print("No user was set!")
            return self.user!
        }
    }
    
    func setCurrentUser(user: User) {
        self.user = user
    }
}
