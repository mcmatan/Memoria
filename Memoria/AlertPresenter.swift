//
//  AlertPresenter.swift
//  Memoria
//
//  Created by Matan Cohen on 23/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import EmitterKit

class AlertPresenter {
    var showAlertListener: EventListener<String>?
    
    init() {
        self.showAlertListener = Events.shared.showAlert.on({ text in
            self.showAlert(text: text)
        })
    }
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: text, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
    }
}
