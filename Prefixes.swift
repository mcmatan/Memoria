//
//  Prefixes.swift
//  Bounder
//
//  Created by Matan Cohen on 13/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

enum Prefixes: String {
    case label = "lbl",
    textFiled = "tf",
    textView = "tv",
    button = "btn",
    imageView = "img",
    isLoading = "isLoading",
    noPrefix = "noPrefix"
    
    init(string: String) {
        if string.hasPrefix(Prefixes.label.rawValue) {
            self = .label
            return
        }
        if string.hasPrefix(Prefixes.textFiled.rawValue) {
            self = .textFiled
            return
        }
        if string.hasPrefix(Prefixes.textView.rawValue) {
            self = .textView
            return
        }
        if string.hasPrefix(Prefixes.button.rawValue) {
            self = .button
            return
        }
        if string.hasPrefix(Prefixes.imageView.rawValue) {
            self = .imageView
            return
        }
        if string.hasPrefix(Prefixes.isLoading.rawValue) {
            self = .isLoading
            return
        }
        self = .noPrefix
    }
}

enum Sefixes: String {
    case placeHolder = "PlaceHolder",
    onPress = "OnPress",
    unabled = "Unabled",
    title = "Title"
}
