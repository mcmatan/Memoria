//
//  RootViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 11/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import EmitterKit

class RootViewController: ViewController {
    let logInViewController: UIViewController
    lazy var mainApplicationController: UIViewController = {
        return ServiceLocator.locate(NavigationController.self)!
    }()
    var loginListener: EventListener<Any>?
    var logoutListener: EventListener<Any>?
    
    init(logInViewController: UIViewController) {
        self.logInViewController = logInViewController
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentLogIn() {
        self.present(viewController: self.logInViewController)
    }
    
    func presentMainApplication() {
        self.present(viewController: self.mainApplicationController)
    }
    
    func present(viewController: UIViewController) {
        if self.presentedViewController === viewController {
            return
        }
        
        if let isPresentedViewController = self.presentedViewController {
            isPresentedViewController.dismiss(animated: true, completion: {
                self.present(viewController, animated: true, completion: nil)
            })
        } else {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
