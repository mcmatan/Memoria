//
//  DictionaryExntentions.swift
//  Memoria
//
//  Created by Matan Cohen on 2/13/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

extension Dictionary {

    public mutating func removeValuesForKeys(keys : Array<Key>) {
        for key in keys {
            self.removeValueForKey(key)
        }
    }
}