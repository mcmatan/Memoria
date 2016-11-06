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

class LocalNotificationPresenter {
    
    static func showLocalNotificationForTask(task: Task, localNotificationCategotry:  LocalNotificationCategotry) {
        switch localNotificationCategotry {
        case LocalNotificationCategotry.notification:
            self.showNotificationCategory(task: task)
        case LocalNotificationCategotry.warning:
            self.showWarningCategory(task: task)
        case LocalNotificationCategotry.verification:
            self.showVerificationCategory(task: task)
        default: break
        }
    }
    
    static func showNotificationCategory(task: Task) {
        let currentDate = Date()
        let userName = Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpUserName")
        let goodTimeOfDatString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpGoodTimeOfDay"), (task.taskTime!.dateToDayPartDeifinisionString()), userName)
        let timeForString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpItsTimeFor"), currentDate.toStringCurrentRegionShortTime(), (task.taskType.name)())
        
        LocalNotificationPresenter.showLocalNotification(title: "Notification", subtitle: (task.taskType.name()), body: goodTimeOfDatString + " " + timeForString, localNotificationCategory: LocalNotificationCategotry.notification)
    }
    
    static func showWarningCategory(task: Task) {
        let didAllreadyString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidAllready"), task.taskType.name())
        let laterTodayString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidLaterToday"), task.taskType.name())
        let warningString = (task.taskTime! <= Date()) ? didAllreadyString : laterTodayString
        
        let didAllreadyStringBecareful = Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidCerfulNotToTakeTwice")
        let laterTodayStringBecareful = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidPleaseWaitFor"), task.taskTime!.toStringCurrentRegionShortTime())
        let beCarefulString = (task.taskTime! <= Date()) ? didAllreadyStringBecareful : laterTodayStringBecareful
        
        LocalNotificationPresenter.showLocalNotification(title: "Warning", subtitle: task.taskType.name(), body: warningString + " " + beCarefulString, localNotificationCategory: LocalNotificationCategotry.warning)
    }
    
    static func showVerificationCategory(task: Task) {
        let iSeeYourNear = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpISeeYourNeer"), (task.taskType.name)())
        let didYouYet = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpDidYouYet"), (task.taskType.name)())
        LocalNotificationPresenter.showLocalNotification(title: "Verification", subtitle: (task.taskType.name()), body: iSeeYourNear + " " + didYouYet, localNotificationCategory: LocalNotificationCategotry.verification)

    }

    static func showLocalNotification(title: String, subtitle: String, body: String, localNotificationCategory: LocalNotificationCategotry) {
        self.showLocalNotification(title: title, subtitle: subtitle, body: body, localNotificationCategory: localNotificationCategory, date: nil)
    }
    
    static func showLocalNotification(title: String, subtitle: String, body: String, localNotificationCategory: LocalNotificationCategotry, date: Date?) {
        self.showLocalNotification(title: title, subtitle: subtitle, body: body, localNotificationCategory: localNotificationCategory, date: date, userInfo: nil)
    }
    
    static func showLocalNotification(title: String, subtitle: String, body: String, localNotificationCategory: LocalNotificationCategotry, date: Date?, userInfo: [String: Any]?, sound: URL?, imageURL: URL?) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.default()
        //content.categoryIdentifier = localNotificationCategory.rawValue
        content.categoryIdentifier = "notification"
        if let isUserInfo = userInfo {
            content.userInfo = isUserInfo
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
    
    func getAttachments(sound: URL?, image: URL?) {
        if let isSound = sound {
            let imgURL = Bundle.main.url("notification", withExtension: "mp3")
            let notificationOptions = [UNNotificationAttachmentOptionsTypeHintKey:kUTTypeMP3]
            
            /// Creating an attachment object
            let notificationImageAttachment =  try UNNotificationAttachment(identifier: "audio_identifier", url:imgURL! , options: notificationOptions)
            sendUILocalNotificationWithAttachment(notificationAttachment: notificationImageAttachment)
        }
    }
}
