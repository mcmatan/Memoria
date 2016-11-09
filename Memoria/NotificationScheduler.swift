//
//  Scheduler.swift
//  Memoria
//
//  Created by Matan Cohen on 3/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate
import UserNotifications

class NotificationScheduler : NSObject {
    static var TaskNotificationKey : String = "nearableIdentifier"
    
    internal func squeduleReminderForTask(_ task : Task) {
        self.squeduleReminderForTask(task, date: task.taskTime!)
    }
    
    internal func squeduleReminderForTask(_ task : Task, date: Date) {
        LocalNotificationPresenter.showLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.notification, date: date)
    }
    
    internal func cancelReminderForTask(_ task : Task) {
        let allCaterogies = LocalNotificationCategoryBuilder.getAllCategoriesFor(taskType: task.taskType)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: allCaterogies)
    }
}
