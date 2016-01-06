//
//  Task.swift
//  Memoria
//
//  Created by Matan Cohen on 12/14/15.
//  Copyright © 2015 MACMatan. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    
    init(name : String, createdAt: NSDate) {
        self.name = name
        self.createdAt = createdAt
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
