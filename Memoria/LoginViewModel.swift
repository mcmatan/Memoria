//
//  LoginViewModel.swift
//  Memoria
//
//  Created by Matan Cohen on 15/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import RxSwift
import EmitterKit

class LoginViewModel: ViewModel {
    
    let loginService: LoginService
    let userNamePlaceHolder = Variable(Content.getContent(ContentType.labelTxt, name: "passwordPlaceHolder"))
    let passwordPlaceHolder = Variable(Content.getContent(ContentType.labelTxt, name: "userNamePlaceHolder"))
    let userName = Variable("matan@memoria-tech.com")
    let password = Variable("7437711")
    let btnLogIn = Variable<Void>()
    let btnLogInTitle = Variable(Content.getContent(ContentType.labelTxt, name: "LogInBtn"))
    let logo = Variable<UIImage>(UIImage(named: "logo")!)
    let error = Variable("")
    let isLoading = Variable<Bool>(false)
    
    
    init(loginService: LoginService) {
        self.loginService = loginService
        self.bindings()
    }
    
    func bindings() {
        let _ = self.btnLogIn.asObservable().skip(1).subscribe { event in
            self.login()
        }
    }
    
    func login() {
        self.error.value = ""
        self.isLoading.value = true
        self.loginService.logIn(email: self.userName.value, password: self.password.value) { success, error in
            self.isLoading.value = false
            if (success) {} else {
                self.error.value = error!
            }
        }
        
    }
    
}
