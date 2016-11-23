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

let TaskNotificationUid : String = "TaskNotificationUid"
class NotificationScheduler {
    
    init() {
        LocalNotificationActions.setupActions()
    }
    
    func cancelNotification(task : Task) {
        //TBD
    }
    
    func squeduleNotification(task : Task) {
        
        let notificationText = NotificationsTextsBuilder.getNotificationText(task: task)
        let title = notificationText.title
        let subtitle = ""
        let body = notificationText.body
        let imageURL = task.taskType.imageURL()
        let caregtoryIdentifer = CaregtoryIdentifer.from(task: task)
        let sound = UNNotificationSound(named: "\(caregtoryIdentifer).aiff")
        let uid = task.uid
        let key = TaskNotificationUid
        let userInfo = [key: uid]
        let attachments = [UNNotificationAttachment.with(imageURL: imageURL)]
        
        
        let content = UNMutableNotificationContent.with(tite: title,
                                          subtitle: subtitle,
                                          body: body,
                                          sound: sound,
                                          categoryIdentifier: caregtoryIdentifer,
                                          userInfo: userInfo,
                                          attachments: attachments)()
        
        let trigger = UNNotificationTrigger.with(date: date)
        
        let requestIdentifier = content.categoryIdentifier
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content,trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let isError = error {
                print("Error on notification reuqest = \(isError)")
            }
        }
    }
    
}
