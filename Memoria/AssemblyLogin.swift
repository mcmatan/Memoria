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

    class func run(_ container : Container) {
        
        container.register(CurrentUserContext.self) { c in
            return CurrentUserContext()
        }.inObjectScope(ObjectScope.container)
        
        container.register(FireBaseCoreWrapper.self) { c in
            return FireBaseCoreWrapper()
            }.inObjectScope(ObjectScope.container)
        let _ = container.resolve(FireBaseCoreWrapper.self)
        
        container.register(LoginService.self) { c in
            return LoginService(
                fireBaseCoreWrapper: container.resolve(FireBaseCoreWrapper.self)!,
                currentUserContext: container.resolve(CurrentUserContext.self)!
                )
        }
        
        container.register(LoginViewModel.self) { c in
            return LoginViewModel(loginService: container.resolve(LoginService.self)!)
        }
        
        container.register(LogInViewController.self) { c in
            return LogInViewController(viewModel: container.resolve(LoginViewModel.self)!)
            }.inObjectScope(ObjectScope.container)
        
        container.register(RootViewController.self) { c in
            return RootViewController(
                logInViewController: container.resolve(LogInViewController.self)!
            )
        }
        
        container.register(AlertPresenter.self) { c in
            return AlertPresenter()
        }.inObjectScope(.container)
        let _ = container.resolve(AlertPresenter.self)
    }
}
