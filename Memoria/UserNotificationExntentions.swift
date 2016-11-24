//
//  UserNotificationsTools.swift
//  Memoria
//
//  Created by Matan Cohen on 22/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UserNotifications

extension UNNotificationTrigger {
    static func with(hour: Int, minute: Int, day: Int)->UNNotificationTrigger {
        var fireDateRepeat = DateComponents()
        fireDateRepeat.hour = hour
        fireDateRepeat.minute = minute
        fireDateRepeat.day = day
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateRepeat, repeats: true)
        return trigger
    }
}

extension UNNotificationAttachment {
    static func with(imageURL: URL)->UNNotificationAttachment {
        let notificationImageAttachment = try! UNNotificationAttachment(identifier: "jpg_identifier", url:imageURL , options: nil)
        return notificationImageAttachment
    }
}

extension UNMutableNotificationContent {
    static func with(title: String,
                     subtitle: String,
                     body: String,
                     sound: UNNotificationSound,
                     categoryIdentifier: String,
                     userInfo: [String: String],
                     attachments: [UNNotificationAttachment]
        ) -> UNMutableNotificationContent {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.userInfo = userInfo
        content.attachments = attachments
        return content
    }
}
