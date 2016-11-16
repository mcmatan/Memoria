//
//  Bounder.swift
//  Bounder
//
//  Created by Matan Cohen on 13/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class Bounder {
    static func bound(view: Any, toViewModel: Any) {
        
        let viewMirror = Mirror(reflecting: view)
        let viewChildren = viewMirror.children
        
        self.boundViewChilden(children: viewChildren, toViewModel: toViewModel)
    }
    
    static func boundViewChilden(children: Mirror.Children, toViewModel: Any) {
        for child in children {
            self.boundViewChild(child: child, toViewModel: toViewModel)
        }
    }
    
    static func boundViewChild(child: Mirror.Child, toViewModel: Any) {
        let labelName = child.label
        let prefix = Prefixes(string: labelName!)
        
        switch prefix {
        case .label:
            let labelNameWithoutPrefix = labelName?.replacingOccurrences(of: Prefixes.label.rawValue , with: "")
            self.bound(label: child.value as! UILabel,labelNameWithoutPrefix: labelNameWithoutPrefix!, toViewModel: toViewModel)
        case .textFiled:
            let labelNameWithoutPrefix = labelName?.replacingOccurrences(of: Prefixes.textFiled.rawValue , with: "")
            self.bound(textFiled: child.value as! UITextField,textFieldNameWithoutPrefix: labelNameWithoutPrefix!, toViewModel: toViewModel)
        case .textView:
            let labelNameWithoutPrefix = labelName?.replacingOccurrences(of: Prefixes.textView.rawValue , with: "")
            self.bound(textView: child.value as! UITextView,textViewNameWithoutPrefix: labelNameWithoutPrefix!, toViewModel: toViewModel)
        case .button:
            let labelNameWithoutPrefix = labelName?.replacingOccurrences(of: Prefixes.button.rawValue , with: "")
            self.bound(button: child.value as! UIButton, buttonNameWithoutPrefix: labelNameWithoutPrefix!, toViewModel: toViewModel)
        case .imageView:
            let labelNameWithoutPrefix = labelName?.replacingOccurrences(of: Prefixes.imageView.rawValue , with: "")
            self.bound(imageView: child.value as! UIImageView, imageViewNameWithoutPrefix: labelNameWithoutPrefix!, toViewModel: toViewModel)
        case .isLoading:
            let labelNameWithoutPrefix = labelName?.replacingOccurrences(of: Prefixes.isLoading.rawValue , with: "")
            self.bound(isLoading: child.value as! Variable<Bool>, isLoadingNameWithoutPrefix: labelNameWithoutPrefix!, toViewModel: toViewModel)
        case .noPrefix:
            print("")
        }
    }

    static func bound(label: UILabel, labelNameWithoutPrefix: String, toViewModel: Any) {
        Observers.observerViewModelValue(viewMode: toViewModel, withPropName: labelNameWithoutPrefix, valueChange: { value, propName in
            label.text = value as? String
        })
    }
    
    static func bound(textFiled: UITextField, textFieldNameWithoutPrefix: String, toViewModel: Any) {
        let viewModelMirror = Mirror(reflecting: toViewModel)
        let viewModelChildren = viewModelMirror.children
        
        for child in viewModelChildren {
            let childPropName = child.label!
            
            if (childPropName.lowercased().contains(textFieldNameWithoutPrefix.lowercased())) {
                if let isString = child.value as? Variable<String> {
                    let _ =  (textFiled.rx.textInput <-> isString)
                }
            }
            
            if childPropName.hasSuffix(Sefixes.placeHolder.rawValue) == true {
                if let isString = child.value as? Variable<String> {
                        textFiled.placeholder = isString.value
                }
            }
        }
    }
    
    static func bound(textView: UITextView, textViewNameWithoutPrefix: String, toViewModel: Any) {
        let viewModelMirror = Mirror(reflecting: toViewModel)
        let viewModelChildren = viewModelMirror.children
        
        for child in viewModelChildren {
            let childPropName = child.label!
                
            if (childPropName.lowercased().contains(textViewNameWithoutPrefix.lowercased())) {
                if let isString = child.value as? Variable<String> {
                    let _ =  (textView.rx.textInput <-> isString)
                }
            }
        }
    }
    
    static func bound(button: UIButton, buttonNameWithoutPrefix: String, toViewModel: Any) {
        
        let viewModelMirror = Mirror(reflecting: toViewModel)
        let viewModelChildren = viewModelMirror.children
        
        //On tap
        let _ = button.rx.tap.subscribe({ value in
            for child in viewModelChildren {
                if (child.label?.lowercased().contains(buttonNameWithoutPrefix.lowercased()))! {
                    if let isObserver = child.value as? Variable<Void>{
                        isObserver.value = ()
                    }
                }
            }
        })
        
        let title = buttonNameWithoutPrefix + Sefixes.title.rawValue
        
        Observers.observerViewModelValue(viewMode: toViewModel, withPropName: title, valueChange: { value, propName in
            button.setTitle(value as? String, for: UIControlState.normal)
        })
        
        let unabled = buttonNameWithoutPrefix + Sefixes.unabled.rawValue
        
        Observers.observerViewModelValue(viewMode: toViewModel, withPropName: unabled, valueChange: { value, propName in
            button.isEnabled = (value as? Bool)!
        })
    }
    
    static func bound(imageView: UIImageView, imageViewNameWithoutPrefix: String, toViewModel: Any) {
        Observers.observerViewModelValue(viewMode: toViewModel, withPropName: imageViewNameWithoutPrefix, valueChange: { value, propName in
            if let isURL = value as? URL {
                imageView.kf.setImage(with: isURL)
            }
            
            if let isImage = value as? UIImage {
                imageView.image = isImage
            }
            
        })
    }
    
    static func bound(isLoading: Variable<Bool>, isLoadingNameWithoutPrefix: String, toViewModel: Any) {
        
        let withLoadingPrefix = Prefixes.isLoading.rawValue + isLoadingNameWithoutPrefix
        let viewModelMirror = Mirror(reflecting: toViewModel)
        let viewModelChildren = viewModelMirror.children
        
        //On tap
            for child in viewModelChildren {
                if (child.label?.lowercased().contains(withLoadingPrefix.lowercased()))! {
                    if let isObserver = child.value as? Variable<Bool>{
                        let _ = isObserver.asObservable().subscribe({ eventreq in
                            isLoading.value = eventreq.element!
                        })
                    }
                }
            }

        
    }

    
}


