//
//  ApplicationExntentions.swift
//  Memoria
//
//  Created by Matan Cohen on 09/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import MobileCoreServices

class LocalNotificationScheduler {
    static var TaskNotificationKey : String = "nearableIdentifier"
    
    func cancelReminderForTask(_ task : Task) {
        let allCaterogies = LocalNotificationCategoryBuilder.getAllCategoriesFor(taskType: task.taskType)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: allCaterogies)
    }
    
    func squeduleReminderForTask(_ task : Task) {
        self.scheduleLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.notification)
    }
    
    func scheduleLocalNotificationForTask(task: Task, localNotificationCategotry:  LocalNotificationCategotry) {
        switch localNotificationCategotry {
        case LocalNotificationCategotry.notification:
            self.scheduleNotification(task: task)
        case LocalNotificationCategotry.warning:
            self.scheduleWarning(task: task)
        case LocalNotificationCategotry.verification:
            self.scheduleVerification(task: task)
        default: break
        }
    }
    
    func scheduleNotification(task: Task) {
        let localNotificationCategory = LocalNotificationCategotry.notification
        let notificationText = NotificationsTextsBuilder.getNotificationText(task: task, localNotificationCategory: localNotificationCategory)
        
        self.scheduleNotification(
            title: notificationText.notificationTitle,
            subtitle: "",
            body: notificationText.notificationBody,
            localNotificationCategory: localNotificationCategory,
            date: date,
            sound: task.taskType.soundURL(localNotificationCategotry: localNotificationCategory),
            imageURL: task.taskType.imageURL(localNotificationCategory: localNotificationCategory),
            task: task)
    }
    
//    func scheduleWarning(task: Task) {
//        let localNotificationCategory = LocalNotificationCategotry.warning
//        let notificationText = NotificationsTextsBuilder.getNotificationText(task: task, localNotificationCategory: localNotificationCategory)
//        
//        self.scheduleNotification(
//            title: notificationText.notificationTitle,
//            subtitle: "",
//            body: notificationText.notificationBody,
//            localNotificationCategory: localNotificationCategory,
//            date: nil,
//            sound: task.taskType.soundURL(localNotificationCategotry: localNotificationCategory),
//            imageURL: task.taskType.imageURL(localNotificationCategory: localNotificationCategory),
//            task: task)
//        
//    }
//    
//    func scheduleVerification(task: Task) {
//        let localNotificationCategory = LocalNotificationCategotry.verification
//        let notificationText = NotificationsTextsBuilder.getNotificationText(task: task, localNotificationCategory: localNotificationCategory)
//        
//        self.scheduleNotification(
//            title: notificationText.notificationTitle,
//            subtitle: "",
//            body: notificationText.notificationBody,
//            localNotificationCategory: localNotificationCategory,
//            date: nil,
//            sound: task.taskType.soundURL(localNotificationCategotry: localNotificationCategory),
//            imageURL: task.taskType.imageURL(localNotificationCategory: localNotificationCategory),
//            task: task)
//
//    }

    func scheduleNotification(title: String, subtitle: String, body: String, localNotificationCategory: LocalNotificationCategotry, date: Date?, sound: URL?, imageURL: URL?, task: Task) {
        
        LocalNotificationActions.setupActions()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        let caregtoryIdentifer = LocalNotificationCategoryBuilder.buildCategory(taskType: task.taskType.rawValue, localNotificationCategory: localNotificationCategory)
        content.sound = UNNotificationSound(named: "\(caregtoryIdentifer).aiff") // This doe't work for now, apple bug
        content.categoryIdentifier = caregtoryIdentifer
        
        let nearableIdentifer = task.nearableIdentifer
        let key = LocalNotificationScheduler.TaskNotificationKey
        let userInfo = [key: nearableIdentifer]

        content.userInfo = userInfo
        
        let attachments = self.getAttachments(soundURL : sound,imageURL: imageURL)
        if attachments.count > 0 {
            content.attachments = attachments
        }
        
        var trigger: UNNotificationTrigger?
        
        if let isDate = date { // Repetetive task
            var fireDateRepeat = DateComponents()
            fireDateRepeat.hour = isDate.hour
            fireDateRepeat.minute = isDate.minute
            trigger = UNCalendarNotificationTrigger(dateMatching: fireDateRepeat, repeats: true)
            
        } else { //One time fire
            var fireTimeInterval = TimeInterval(0.01)
            if fireTimeInterval < 0 {
                fireTimeInterval = 0.01
            }
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: fireTimeInterval, repeats: false)
        }
        
        
        let requestIdentifier = content.categoryIdentifier
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content,trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let isError = error {
                print("Error on notification reuqest = \(isError)")
            }
        }
    }
    
    func getAttachments(soundURL: URL?, imageURL: URL?) -> [UNNotificationAttachment] {
        var attachments = [UNNotificationAttachment]()

        if let isImageURL = imageURL {
            /// Creating an attachment object
            let notificationImageAttachment =  try! UNNotificationAttachment(identifier: "jpg_identifier", url:isImageURL , options: nil)
            attachments.append(notificationImageAttachment)
        }
        return attachments
    }
}
