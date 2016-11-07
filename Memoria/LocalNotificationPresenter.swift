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

class LocalNotificationPresenter {
    
    static func showLocalNotificationForTask(task: Task, localNotificationCategotry:  LocalNotificationCategotry, date: Date = Date()) {
        switch localNotificationCategotry {
        case LocalNotificationCategotry.notification:
            self.showNotificationCategory(task: task, date: date)
        case LocalNotificationCategotry.warning:
            self.showWarningCategory(task: task)
        case LocalNotificationCategotry.verification:
            self.showVerificationCategory(task: task)
        default: break
        }
    }
    
    static func showNotificationCategory(task: Task, date: Date = Date()) {
        let currentDate = Date()
        let userName = Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpUserName")
        let goodTimeOfDatString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpGoodTimeOfDay"), (task.taskTime!.dateToDayPartDeifinisionString()), userName)
        let timeForString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpItsTimeFor"), currentDate.toStringCurrentRegionShortTime(), (task.taskType.name)())
        
        LocalNotificationPresenter.showLocalNotification(title: "Notification", subtitle: (task.taskType.name()), body: goodTimeOfDatString + " " + timeForString, localNotificationCategory: LocalNotificationCategotry.notification, sound: task.taskType.soundURL(localNotificationCategotry: .verification), imageURL: task.taskType.imageURL(), date: date)
    }
    
    static func showWarningCategory(task: Task) {
        let didAllreadyString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidAllready"), task.taskType.name())
        let laterTodayString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidLaterToday"), task.taskType.name())
        let warningString = (task.taskTime! <= Date()) ? didAllreadyString : laterTodayString
        
        let didAllreadyStringBecareful = Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidCerfulNotToTakeTwice")
        let laterTodayStringBecareful = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidPleaseWaitFor"), task.taskTime!.toStringCurrentRegionShortTime())
        let beCarefulString = (task.taskTime! <= Date()) ? didAllreadyStringBecareful : laterTodayStringBecareful
        
        LocalNotificationPresenter.showLocalNotification(title: "Warning", subtitle: task.taskType.name(), body: warningString + " " + beCarefulString, localNotificationCategory: LocalNotificationCategotry.warning, sound: task.taskType.soundURL(localNotificationCategotry: .verification), imageURL: task.taskType.imageURL())
    }
    
    static func showVerificationCategory(task: Task) {
        let iSeeYourNear = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpISeeYourNeer"), (task.taskType.name)())
        let didYouYet = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpDidYouYet"), (task.taskType.name)())
        LocalNotificationPresenter.showLocalNotification(title: "Verification", subtitle: (task.taskType.name()), body: iSeeYourNear + " " + didYouYet, localNotificationCategory: LocalNotificationCategotry.verification, sound: task.taskType.soundURL(localNotificationCategotry: .verification), imageURL: task.taskType.imageURL())

    }

    static func showLocalNotification(title: String, subtitle: String, body: String, localNotificationCategory: LocalNotificationCategotry, sound: URL, imageURL: URL) {
        self.showLocalNotification(title: title, subtitle: subtitle, body: body, localNotificationCategory: localNotificationCategory,sound: sound, imageURL: imageURL, date: nil)
    }
    
    static func showLocalNotification(title: String, subtitle: String, body: String, localNotificationCategory: LocalNotificationCategotry, sound: URL, imageURL: URL, date: Date?) {
        self.showLocalNotification(title: title, subtitle: subtitle, body: body, localNotificationCategory: localNotificationCategory, date: date, userInfo: nil, sound: sound, imageURL: imageURL)
    }
    
    static func showLocalNotification(title: String, subtitle: String, body: String, localNotificationCategory: LocalNotificationCategotry, date: Date?, userInfo: [String: Any]?, sound: URL?, imageURL: URL?) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        //content.sound = UNNotificationSound.default()
        content.sound = UNNotificationSound(named: "pillsVerification.diff")
        //content.categoryIdentifier = localNotificationCategory.rawValue
        content.categoryIdentifier = "notification"
        if let isUserInfo = userInfo {
            content.userInfo = isUserInfo
        }
        
        
        let attachments = self.getAttachments(soundURL : sound,imageURL: imageURL)
        if attachments.count > 0 {
            content.attachments = attachments
        }
        
        let fireTimeInterval = (date != nil) ? date!.timeIntervalSinceNow : TimeInterval(0.01)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: fireTimeInterval, repeats: false)
        let requestIdentifier = content.categoryIdentifier
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content,trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let isError = error {
                print("Error on notification reuqest = \(isError)")
            }
        }
    }
    
    static func getAttachments(soundURL: URL?, imageURL: URL?) -> [UNNotificationAttachment] {
        var attachments = [UNNotificationAttachment]()
//        if let isSoundURL = soundURL {
//            let notificationOptions = [UNNotificationAttachmentOptionsTypeHintKey:kUTTypeMPEG4Audio]
//            /// Creating an attachment object
//            let notificationImageAttachment =  try! UNNotificationAttachment(identifier: "audio_identifier", url:isSoundURL , options: notificationOptions)
//            attachments.append(notificationImageAttachment)
//        }
//        
        if let isImageURL = imageURL {
            /// Creating an attachment object
            let notificationImageAttachment =  try! UNNotificationAttachment(identifier: "jpg_identifier", url:isImageURL , options: nil)
            attachments.append(notificationImageAttachment)
        }
        return attachments
    }
}
