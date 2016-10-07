//
//  DictionaryExntentions.swift
//  Memoria
//
//  Created by Matan Cohen on 2/13/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

extension Dictionary {

    public mutating func removeValuesForKeys(_ keys : Array<Key>) {
        for key in keys {
            self.removeValue(forKey: key)
        }
    }
}
