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
    static func getLocalNotificationCategory(category: String)-> LocalNotificationCategotry {
        if category.contains(LocalNotificationCategotry.done.rawValue) {
            return LocalNotificationCategotry.done
        }
        if category.contains(LocalNotificationCategotry.notification.rawValue) {
            return LocalNotificationCategotry.notification
        }
        if category.contains(LocalNotificationCategotry.verification.rawValue) {
            return LocalNotificationCategotry.verification
        }
        if category.contains(LocalNotificationCategotry.warning.rawValue) {
            return LocalNotificationCategotry.warning
        }
        print("getLocalNotificationCategory failer")
        return LocalNotificationCategotry(rawValue: "")!
    }
    
    static func getAllCategoriesFor(taskType: TaskType)-> [String] {
        var all = [String]()
        for localNotificationCategotry in LocalNotificationCategotry.allValus() {
            all.append(self.buildCategory(taskType: taskType.rawValue, localNotificationCategory: localNotificationCategotry))
        }
        return all
    }
}
