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
    
    let tfUserName = TextField()
    let tfPassword = TextField()
    let btnLogIn = Button()
    let imgLogo = ImageView(image: UIImage.init())
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        Bounder.bound(view: self, toViewModel: self.viewModel)
    }
    
    func setupView() {
        
        self.imgLogo.contentMode = UIViewContentMode.scaleAspectFill
        self.imgLogo.setHeightAs(50)
        self.btnLogIn.defaultStyle()
        self.btnLogIn.backgroundColor = Colors.green()
        self.tfPassword.defaultStyle()
        self.tfUserName.defaultStyle()
        
        self.view.addSubview(self.imgLogo)
        self.view.addSubview(self.tfUserName)
        self.view.addSubview(self.tfPassword)
        self.view.addSubview(self.btnLogIn)
        
        self.imgLogo.centerHorizontlyInSuperView()
        self.tfPassword.centerHorizontlyInSuperView()
        self.tfUserName.centerHorizontlyInSuperView()
        self.btnLogIn.centerHorizontlyInSuperView()
        
        let paddingBetweenElements = CGFloat(13.0)
        self.imgLogo.topAlighnToViewTop(self.view, offset: 60)
        self.tfUserName.topAlighnToViewBottom(self.imgLogo, offset: 30)
        self.tfPassword.topAlighnToViewBottom(self.tfUserName, offset: paddingBetweenElements)
        self.btnLogIn.topAlighnToViewBottom(self.tfPassword, offset: paddingBetweenElements)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.self.tfUserName.becomeFirstResponder()
    }
}
