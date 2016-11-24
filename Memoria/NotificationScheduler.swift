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
        UNUserNotificationCenter.remove(task: task)
    }
    
    func stopRepeate(contentIdentifer: String) {
        UNUserNotificationCenter.stopRepeate(contentIdentifer: contentIdentifer)
    }
    
    func cancelNotification(task: Task, time: Time, day: Day) {
        UNUserNotificationCenter.remove(task: task, atTime: time, andDay: day)
    }
    
    func squeduleNotification(task : Task) {
        
        let notificationText = NotificationsTextsBuilder.getNotificationText(task: task)
        let title = notificationText.title
        let subtitle = ""
        let body = notificationText.body
        let imageURL = task.taskType.imageURL()
        let sound = UNNotificationSound(named: "\(task.taskType.rawValue)-notification.aiff")
        let uid = task.uid
        let key = TaskNotificationUid
        let userInfo = [key: uid]
        let attachments = [UNNotificationAttachment.with(imageURL: imageURL)]
        
        
        let content = UNMutableNotificationContent.with(title: title,
                                          subtitle: subtitle,
                                          body: body,
                                          sound: sound,
                                          userInfo: userInfo,
                                          attachments: attachments)

        UNUserNotificationCenter.add(task: task, content: content, shouldRepeate: true)
    }
    
}
