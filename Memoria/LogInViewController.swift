//
//  LogInViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 11/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class LogInViewController: ViewController {
    
    let textFieldUserName = TextField()
    let textFiledPassword = TextField()
    let btnLogIn = Button()
    let imgLogo = ImageView(image: UIImage(named: "logo"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgLogo.contentMode = UIViewContentMode.scaleAspectFill
        self.imgLogo.heightLayoutAs(50)
        self.btnLogIn.defaultStyle()
        self.btnLogIn.setTitle(Content.getContent(ContentType.labelTxt, name: "LogInBtn"), for: UIControlState.normal)
        self.btnLogIn.backgroundColor = Colors.green()
        self.textFiledPassword.defaultStyle()
        self.textFiledPassword.placeholder = Content.getContent(ContentType.labelTxt, name: "passwordPlaceHolder")
        self.textFieldUserName.placeholder = Content.getContent(ContentType.labelTxt, name: "userNamePlaceHolder")
        self.textFieldUserName.defaultStyle()
    
        self.view.addSubview(self.imgLogo)
        self.view.addSubview(self.textFieldUserName)
        self.view.addSubview(self.textFiledPassword)
        self.view.addSubview(self.btnLogIn)
        
        self.imgLogo.centerVerticlyInSuperView()
        self.textFiledPassword.centerVerticlyInSuperView()
        self.textFieldUserName.centerVerticlyInSuperView()
        self.btnLogIn.centerVerticlyInSuperView()
        
        let paddingBetweenElements = CGFloat(50.0)
        self.imgLogo.topAlighnToViewTop(self.view, offset: 50)
        self.textFieldUserName.topAlighnToViewTop(self.imgLogo, offset: 100)
        self.textFiledPassword.topAlighnToViewTop(self.textFieldUserName, offset: paddingBetweenElements)
        self.btnLogIn.topAlighnToViewTop(self.textFiledPassword, offset: 50)
        
    }
}
