//
//  LocalNotificationActions.swift
//  Memoria
//
//  Created by Matan Cohen on 08/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UserNotifications

var didSetupCateogories = false

struct NotificationActionIdentifer {
    let identifer: String
    let title: String
}

struct NotificationActionsInfos {
    static let playSound = NotificationActionIdentifer(identifer: "play-sound", title: "Play sound")
    static let verificationConfirm = NotificationActionIdentifer(identifer: "verification-confirm", title: "Yes")
    static let verificationRemindMeLater = NotificationActionIdentifer(identifer: "verification-remind-me-later", title: "Remind me later")
    static let warningThankYou = NotificationActionIdentifer(identifer: "warning-thank-you", title: "Thank you")
}


class LocalNotificationActions {

    static func setupActions() {
        if didSetupCateogories == true {
            return
        }
        didSetupCateogories = true

        var action: UNNotificationAction!
        var category: UNNotificationCategory!
        var categorys = [UNNotificationCategory]()
        let identifer = "Thanks you"
        
        action = UNNotificationAction(identifier: NotificationActionsInfos.playSound.identifer,
                                      title: NotificationActionsInfos.playSound.title,
                                      options: [])
        category = UNNotificationCategory(identifier: identifer, actions: [action], intentIdentifiers: [], options: [])
        categorys.append(category)
        let objectSet = Set(categorys.map { return $0 })
        UNUserNotificationCenter.current().setNotificationCategories(objectSet)
    }
}
