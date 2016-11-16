//
//  LogInViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 11/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class LogInViewController: ViewController {
    
    let tfUserName = TextField()
    let tfPassword = TextField()
    let btnLogIn = Button()
    let imgLogo = ImageView(image: UIImage.init())
    let viewModel: ViewModel
    let isLoading = Variable<Bool>(true)
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let lblError = UILabel()
    
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
        
        
        let _ = self.isLoading.asObservable().subscribe { event in
            event.element! ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
    }
    
    func setupView() {
        
        self.imgLogo.contentMode = UIViewContentMode.scaleAspectFill
        self.imgLogo.setHeightAs(50)
        self.btnLogIn.defaultStyle()
        self.btnLogIn.backgroundColor = Colors.green()
        self.tfPassword.defaultStyle()
        self.tfUserName.defaultStyle()
        self.lblError.textColor = Colors.red()
        self.lblError.setHeightAs(70)
        self.lblError.numberOfLines = 0
        self.activityIndicator.hidesWhenStopped = true
        
        self.view.addSubview(self.imgLogo)
        self.view.addSubview(self.tfUserName)
        self.view.addSubview(self.tfPassword)
        self.view.addSubview(self.btnLogIn)
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(self.lblError)
        
        self.imgLogo.centerHorizontlyInSuperView()
        self.tfPassword.centerHorizontlyInSuperView()
        self.tfUserName.centerHorizontlyInSuperView()
        self.btnLogIn.centerHorizontlyInSuperView()
        self.lblError.centerHorizontlyInSuperView()
        
        let paddingBetweenElements = CGFloat(13.0)
        self.imgLogo.topAlighnToViewTop(self.view, offset: 60)
        self.tfUserName.topAlighnToViewBottom(self.imgLogo, offset: 30)
        self.tfPassword.topAlighnToViewBottom(self.tfUserName, offset: paddingBetweenElements)
        self.btnLogIn.topAlighnToViewBottom(self.tfPassword, offset: paddingBetweenElements)
        self.lblError.topAlighnToViewBottom(self.btnLogIn, offset: 6)
        self.lblError.leadingToSuperView(true)
        self.lblError.trailingToSuperView(true)
        self.activityIndicator.centerInSuperView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.self.tfUserName.becomeFirstResponder()
    }
}
