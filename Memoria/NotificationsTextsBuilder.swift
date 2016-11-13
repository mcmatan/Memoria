//
//  NotificationsTextsBuilder.swift
//  Memoria
//
//  Created by Matan Cohen on 13/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

struct NotificationText {
    let popUpTitle: String
    let popUpBody: String
    let notificationTitle: String
    let notificationBody: String
}

class NotificationsTextsBuilder {
    
    static func getNotificationText(task: Task, localNotificationCategory: LocalNotificationCategotry)->NotificationText {
        switch task.taskType {
        case TaskType.brushTeeth:
            return self.bruthTeeth(localNotificationCategory: localNotificationCategory, taskDate: task.taskTime!)
        case TaskType.drugs:
            return self.drugs(localNotificationCategory: localNotificationCategory, taskDate: task.taskTime!)
        case TaskType.food:
            return self.food(localNotificationCategory: localNotificationCategory, taskDate: task.taskTime!)
        }
    }
        
    static func bruthTeeth(localNotificationCategory: LocalNotificationCategotry, taskDate: Date)->NotificationText {
        switch localNotificationCategory {
        case .warning:
            let popUpTitle = "You have already brushed your teeth earlier!"
            let notificationTitle = "You already brushed your teeth earlier!"
            let body = "Are you sure you want to do that again?"
            return NotificationText(popUpTitle: popUpTitle, popUpBody: body, notificationTitle: notificationTitle, notificationBody: body)
        case .notification:
            let goodTimeOfDayString = self.goodTimeOfDayString(date: taskDate)
            let timeForString = self.itsTimeWithTime(date: taskDate)
            let title = goodTimeOfDayString
            let body = "\(timeForString). time to brush your teeth."
            return NotificationText(popUpTitle: title, popUpBody: body, notificationTitle: title, notificationBody: body)
        case .verification:
            let popUpTitle = "Hi there! I’ve noticed you are using your toothbrush."
            let notificationTitle = "You are using your toothbrush."
            let body = "Are you brushing your teeth right now?"
            return NotificationText(popUpTitle: popUpTitle, popUpBody: body, notificationTitle: notificationTitle, notificationBody: body)
        case .done:
            let title = "Brushing teeth marked as done."
            let body = ""
            return NotificationText(popUpTitle: title, popUpBody: body, notificationTitle: title, notificationBody: body)
        }
    }

    static func drugs(localNotificationCategory: LocalNotificationCategotry, taskDate: Date)->NotificationText {
        switch localNotificationCategory {
        case .warning:
            let popUpTitle = "You have already took your medicine at \(taskDate.toStringCurrentRegionShortTime())"
            let notificationTitle = "You already took your medicine today"
            let body = "Carefull not to take too many."
               return NotificationText(popUpTitle: popUpTitle, popUpBody: body, notificationTitle: notificationTitle, notificationBody: body)
        case .notification:
            let goodTimeOfDayString = self.goodTimeOfDayString(date: taskDate)
            let timeForString = self.itsTimeWithTime(date: taskDate)
            let title = goodTimeOfDayString
            let body = "\(timeForString). Time to go and take your pills."
               return NotificationText(popUpTitle: title, popUpBody: body, notificationTitle: title, notificationBody: body)
        case .verification:
            let popUpTitle = "Hi there! I’ve noticed you opened your pill box."
            let notificationTitle = "I’ve noticed you opened your pill box."
            let body = "Are you taking your pills right now?"
            return NotificationText(popUpTitle: popUpTitle, popUpBody: body, notificationTitle: notificationTitle, notificationBody: body)
        case .done:
            let title = "Taking pills marked as done."
            let body = ""
            return NotificationText(popUpTitle: title, popUpBody: body, notificationTitle: title, notificationBody: body)
        }
    }

    static func food(localNotificationCategory: LocalNotificationCategotry, taskDate: Date)->NotificationText {
        switch localNotificationCategory {
        case .warning:
            let title = "You have already made dinner today!"
            let body = "Are you sure you want to do that again?"
            return NotificationText(popUpTitle: title, popUpBody: body, notificationTitle: title, notificationBody: body)
        case .notification:
            let goodTimeOfDayString = self.goodTimeOfDayString(date: taskDate)
            let timeForString = self.itsTimeWithTime(date: taskDate)
            let title = goodTimeOfDayString
            let body = "\(timeForString). Time to make dinner."
            return NotificationText(popUpTitle: title, popUpBody: body, notificationTitle: title, notificationBody: body)
        case .verification:
            let popUpTitle = "Hi there! I’ve noticed you opened your fridge"
            let notificationTitle = "I’ve noticed you opened your fridge"
            let body = "Are you making dinner?"
            return NotificationText(popUpTitle: popUpTitle, popUpBody: body, notificationTitle: notificationTitle, notificationBody: body)
        case .done:
            let title = "Making dinner marked as done."
            let body = ""
            return NotificationText(popUpTitle: title, popUpBody: body, notificationTitle: title, notificationBody: body)
        }
    }

    static func goodTimeOfDayString(date: Date)->String {
        let goodTimeOfDayString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpGoodTimeOfDay"), date.dateToDayPartDeifinisionString())
        return goodTimeOfDayString
    }
    
    static func itsTimeWithTime(date: Date)->String {
        let timeForString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpItsTimeWithTime"), date.toStringCurrentRegionShortTime())
        return timeForString
    }
}
