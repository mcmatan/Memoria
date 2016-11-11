//
//  RootViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 11/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: ViewController {
    let logInViewController: UIViewController
    let mainApplicationController: UIViewController
    
    init(logInViewController: UIViewController, mainApplicationController: UIViewController) {
        self.mainApplicationController = mainApplicationController
        self.logInViewController = logInViewController
        super.init(nibName: nil, bundle: nil)
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
        if let isPresentedViewController = self.presentedViewController {
            isPresentedViewController.dismiss(animated: true, completion: {
                self.present(viewController, animated: true, completion: nil)
            })
        } else {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
