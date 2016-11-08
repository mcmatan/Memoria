//
//  LocalNotificationCategoryBuilder.swift
//  Memoria
//
//  Created by Matan Cohen on 08/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

class LocalNotificationCategoryBuilder {
    static func buildCategory(taskType: String, localNotificationCategory: LocalNotificationCategotry)->String {
        return "\(taskType)-\(localNotificationCategory.rawValue)"
    }
}
