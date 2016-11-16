//
//  LoginViewModel.swift
//  Memoria
//
//  Created by Matan Cohen on 15/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import RxSwift


class LoginViewModel: ViewModel {
    
    let fireBaseWrapper: FireBaseWrapper
    let userNamePlaceHolder = Variable(Content.getContent(ContentType.labelTxt, name: "passwordPlaceHolder"))
    let passwordPlaceHolder = Variable(Content.getContent(ContentType.labelTxt, name: "userNamePlaceHolder"))
    let userName = Variable("")
    let password = Variable("")
    let btnLogIn = Variable<Void>()
    let btnLogInTitle = Variable(Content.getContent(ContentType.labelTxt, name: "LogInBtn"))
    let logo = Variable<UIImage>(UIImage(named: "logo")!)
    let error = Variable("")
    let isLoading = Variable<Bool>(false)
    
    
    init(fireBaseWrapper: FireBaseWrapper) {
        self.fireBaseWrapper = fireBaseWrapper
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
        self.fireBaseWrapper.logIn(email: self.userName.value, password: self.password.value) { success, error in
            self.isLoading.value = false
            self.error.value = error!
        }
        
    }
    
}
