//
//  Observers.swift
//  Bounder
//
//  Created by Matan Cohen on 15/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import RxSwift
import Kingfisher
import UIKit
import RxCocoa


class Observers {
    static func observerViewModelValue(viewMode: Any, withPropName: String, valueChange: @escaping (_ value: Any, _ propName: String)-> Void) {
        let viewModelMirror = Mirror(reflecting: viewMode)
        let viewModelChildren = viewModelMirror.children
        
        for child in viewModelChildren {
            if (child.label?.lowercased().contains(withPropName.lowercased()))! {
                
                //String
                if let isString = child.value as? Variable<String> {
                    let _  = isString.asObservable().subscribe(onNext: { viewModelValue in
                        valueChange(viewModelValue, child.label!)
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
                }
                
                //URL
                if let isURL = child.value as? Variable<URL> {
                    let _  = isURL.asObservable().subscribe(onNext: { viewModelValue in
                        valueChange(viewModelValue, child.label!)
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
                }
                
                //Bool
                if let isBool = child.value as? Variable<Bool> {
                    let _  = isBool.asObservable().subscribe(onNext: { viewModelValue in
                        valueChange(viewModelValue, child.label!)
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
                }
                
                //Image
                if let isImage = child.value as? Variable<UIImage> {
                    let _  = isImage.asObservable().subscribe(onNext: { viewModelValue in
                        valueChange(viewModelValue, child.label!)
                    }, onError: nil, onCompleted: nil, onDisposed: nil)
                }
            }
        }
    }
    
}
