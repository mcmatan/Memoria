//
//  AssemblyLogin.swift
//  Memoria
//
//  Created by Matan Cohen on 16/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import Swinject

open class AssemblyLogin {

    class func run(_ loginContainer : Container) {
        
        loginContainer.register(CurrentUserContext.self) { c in
            return CurrentUserContext()
        }.inObjectScope(ObjectScope.container)
        
        
        loginContainer.register(LoginService.self) { c in
            return LoginService(
                currentUserContext: loginContainer.resolve(CurrentUserContext.self)!
                )
        }.inObjectScope(.container)
        let _ = loginContainer.resolve(LoginService.self)
        
        loginContainer.register(LoginViewModel.self) { c in
            return LoginViewModel(loginService: loginContainer.resolve(LoginService.self)!)
        }
        
        loginContainer.register(LogInViewController.self) { c in
            return LogInViewController(viewModel: loginContainer.resolve(LoginViewModel.self)!)
            }.inObjectScope(ObjectScope.container)
        
        loginContainer.register(RootViewController.self) { c in
            return RootViewController(
                logInViewController: loginContainer.resolve(LogInViewController.self)!
            )
        }
        
        loginContainer.register(AlertPresenter.self) { c in
            return AlertPresenter()
        }.inObjectScope(.container)
        let _ = loginContainer.resolve(AlertPresenter.self)
    }
}
