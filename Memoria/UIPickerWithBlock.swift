//
//  UIPickerWithBlock.swift
//  Memoria
//
//  Created by Matan Cohen on 06/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class UIPickerWithBlock: NSObject, UIPickerViewDelegate , UIPickerViewDataSource {
    let presentingViewController: UIViewController
    let completion: (_ index: Int, _ title: String) -> Void
    let titles: [String]
    let pickerView = UIPickerView()
    
    init(viewController: UIViewController ,titles: [String], completion: @escaping ((_ index: Int, _ title: String) -> Void)) {
        self.completion = completion
        self.presentingViewController = viewController
        self.titles = titles
        super.init()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.frame = CGRect(x: 0,y: 0,
                                       width: presentingViewController.view.frame.size.width,
                                       height: presentingViewController.view.frame.size.height)
        self.presentingViewController.view.addSubview(self.pickerView)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.titles.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.completion(row, self.titles[row])
        self.pickerView.removeFromSuperview()
    }
}
