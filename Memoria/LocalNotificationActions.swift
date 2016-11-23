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
//        
//        var localNotificationCaterogy: LocalNotificationCategotry!
//        var action: UNNotificationAction!
//        var action2: UNNotificationAction!
//        var identifer: String!
//        var category: UNNotificationCategory!
//        var categorys = [UNNotificationCategory]()
//        
//        for taskType in TaskType.getAllValus() {
//            
//            
//            //Notification category
//            
//            localNotificationCaterogy = LocalNotificationCategotry.notification
//            action = UNNotificationAction(identifier:NotificationActionsInfos.playSound.identifer,
//                                              title:NotificationActionsInfos.playSound.title,
//                                              options:[])
//            identifer = LocalNotificationCategoryBuilder.buildCategory(taskType: taskType.rawValue, localNotificationCategory: localNotificationCaterogy)
//            category = UNNotificationCategory(identifier: identifer, actions: [action], intentIdentifiers: [], options: [])
//            categorys.append(category)
//            
//            //Warning category
//            
//            localNotificationCaterogy = LocalNotificationCategotry.warning
//            action = UNNotificationAction(identifier:NotificationActionsInfos.warningThankYou.identifer,
//                                          title:NotificationActionsInfos.warningThankYou.title,
//                                          options:[])
//            identifer = LocalNotificationCategoryBuilder.buildCategory(taskType: taskType.rawValue, localNotificationCategory: localNotificationCaterogy)
//            category = UNNotificationCategory(identifier: identifer, actions: [action], intentIdentifiers: [], options: [])
//            categorys.append(category)
//            
//            //Verification category
//            
//            localNotificationCaterogy = LocalNotificationCategotry.verification
//            action = UNNotificationAction(identifier:NotificationActionsInfos.verificationConfirm.identifer,
//                                          title:NotificationActionsInfos.verificationConfirm.title,
//                                          options:[])
//            identifer = LocalNotificationCategoryBuilder.buildCategory(taskType: taskType.rawValue, localNotificationCategory: localNotificationCaterogy)
//            
//            localNotificationCaterogy = LocalNotificationCategotry.verification
//            action2 = UNNotificationAction(identifier:NotificationActionsInfos.verificationRemindMeLater.identifer,
//                                          title:NotificationActionsInfos.verificationRemindMeLater.title,
//                                          options:[])
//            identifer = LocalNotificationCategoryBuilder.buildCategory(taskType: taskType.rawValue, localNotificationCategory: localNotificationCaterogy)
//            category = UNNotificationCategory(identifier: identifer, actions: [action, action2], intentIdentifiers: [], options: [])
//            categorys.append(category)
//            
//            
//            
//            //Final
//            let objectSet = Set(categorys.map { return $0 })
//            UNUserNotificationCenter.current().setNotificationCategories(objectSet)
//        }
    }
}
