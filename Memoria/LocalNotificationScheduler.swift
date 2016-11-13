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
        self.squeduleReminderForTask(task, date: task.taskTime!)
    }
    
    func squeduleReminderForTask(_ task : Task, date: Date) {
        self.scheduleLocalNotificationForTask(task: task, localNotificationCategotry: LocalNotificationCategotry.notification, date: date)
    }
    
    func scheduleLocalNotificationForTask(task: Task, localNotificationCategotry:  LocalNotificationCategotry, date: Date = Date()) {
        switch localNotificationCategotry {
        case LocalNotificationCategotry.notification:
            self.scheduleNotification(task: task, date: date)
        case LocalNotificationCategotry.warning:
            self.scheduleWarning(task: task)
        case LocalNotificationCategotry.verification:
            self.scheduleVerification(task: task)
        default: break
        }
    }
    
    func scheduleNotification(task: Task, date: Date = Date()) {
        let currentDate = Date()
        let userName = Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpUserName")
        let goodTimeOfDatString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpGoodTimeOfDay"), (task.taskTime!.dateToDayPartDeifinisionString()), userName)
        let timeForString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpItsTimeWithTime"), currentDate.toStringCurrentRegionShortTime(), (task.taskType.name)())
        
        self.scheduleNotification(
            title: "Notification",
            subtitle: (task.taskType.name()),
            body: goodTimeOfDatString + " " + timeForString,
            localNotificationCategory: LocalNotificationCategotry.notification,
            date: date,
            sound: task.taskType.soundURL(localNotificationCategotry: .verification),
            imageURL: task.taskType.imageURL(localNotificationCategory: LocalNotificationCategotry.notification),
            task: task)
    }
    
    func scheduleWarning(task: Task) {
        let didAllreadyString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidAllready"), task.taskType.name())
        let laterTodayString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidLaterToday"), task.taskType.name())
        let warningString = (task.taskTime! <= Date()) ? didAllreadyString : laterTodayString
        
        let didAllreadyStringBecareful = Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidCerfulNotToTakeTwice")
        let laterTodayStringBecareful = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidPleaseWaitFor"), task.taskTime!.toStringCurrentRegionShortTime())
        let beCarefulString = (task.taskTime! <= Date()) ? didAllreadyStringBecareful : laterTodayStringBecareful
        
        self.scheduleNotification(
            title: "Warning",
            subtitle: task.taskType.name(),
            body: warningString + " " + beCarefulString,
            localNotificationCategory: LocalNotificationCategotry.warning,
            date: nil,
            sound: task.taskType.soundURL(localNotificationCategotry: .verification),
            imageURL: task.taskType.imageURL(localNotificationCategory: LocalNotificationCategotry.warning),
            task: task)
        
    }
    
    func scheduleVerification(task: Task) {
        let iSeeYourNear = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpISeeYourNeer"), (task.taskType.name)())
        let didYouYet = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpDidYouYet"), (task.taskType.name)())
        
        self.scheduleNotification(
            title: "Verification",
            subtitle: (task.taskType.name()),
            body: iSeeYourNear + " " + didYouYet,
            localNotificationCategory: LocalNotificationCategotry.verification,
            date: nil,
            sound: task.taskType.soundURL(localNotificationCategotry: .verification),
            imageURL: task.taskType.imageURL(localNotificationCategory: LocalNotificationCategotry.verification),
            task: task)

    }

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
        
        var fireTimeInterval = (date != nil) ? date!.timeIntervalSinceNow : TimeInterval(0.01)
        if fireTimeInterval < 0 {
            fireTimeInterval = 0.01
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: fireTimeInterval, repeats: false)
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
