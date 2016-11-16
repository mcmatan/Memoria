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
    
    let userNamePlaceHolder = Variable(Content.getContent(ContentType.labelTxt, name: "passwordPlaceHolder"))
    let passwordPlaceHolder = Variable(Content.getContent(ContentType.labelTxt, name: "userNamePlaceHolder"))
    let userName = Variable("")
    let password = Variable("")
    let btnLogIn = Variable<Void>()
    let btnLogInTitle = Variable(Content.getContent(ContentType.labelTxt, name: "LogInBtn"))
    let logo = Variable<UIImage>(UIImage(named: "logo")!)
    
    
    init() {
        self.userName.asObservable().subscribe { eventreq in
            print(eventreq.element)
        }
        
        self.password.asObservable().subscribe { eventreq in
            print(eventreq.element)
        }
        
        self.btnLogIn.asObservable().subscribe { press in
            print("Did press")
        }
    }
    
}
