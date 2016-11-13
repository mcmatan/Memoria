//
//  NotificationsTextsBuilder.swift
//  Memoria
//
//  Created by Matan Cohen on 13/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation

struct NotificationText {
    let title: String
    let body: String
}

class NotificationsTextsBuilder {
    
    func getNotificationText(task: Task, localNotificationCategory: LocalNotificationCategotry)->NotificationText {
        switch task.taskType {
        case TaskType.brushTeeth:
            return self.bruthTeeth(localNotificationCategory: localNotificationCategory, taskDate: task.taskTime!)
        case TaskType.drugs:
            return self.drugs(localNotificationCategory: localNotificationCategory, taskDate: task.taskTime!)
        case TaskType.food:
            return self.food(localNotificationCategory: localNotificationCategory, taskDate: task.taskTime!)
        }
    }
        
    func bruthTeeth(localNotificationCategory: LocalNotificationCategotry, taskDate: Date)->NotificationText {
        switch localNotificationCategory {
        case .warning:
            let title = "You have already brushed your teeth earlier!"
            let body = "Are you sure you want to do that again?"
            return NotificationText(title: title, body: body)
        case .notification:
            let goodTimeOfDayString = self.goodTimeOfDayString(date: taskDate)
            let timeForString = self.itsTimeWithTime(date: taskDate)
            let title = goodTimeOfDayString
            let body = "\(timeForString). time to Brush your teeth."
            return NotificationText(title: title, body: body)
        case .verification:
            let title = "Hi there! i’ve noticed you are using your toothbrush."
            let body = "Are you brushing your teeth right now?"
            return NotificationText(title: title, body: body)
        case .done:
            return NotificationText(title: "Brushing teeth marked as done.", body: "")
        }
    }

    func drugs(localNotificationCategory: LocalNotificationCategotry, taskDate: Date)->NotificationText {
        switch localNotificationCategory {
        case .warning:
            let title = "You have already took your medicine at \(taskDate.toStringCurrentRegionShortTime())"
            let body = "Carefull not to take too many."
            return NotificationText(title: title, body: body)
        case .notification:
            let goodTimeOfDayString = self.goodTimeOfDayString(date: taskDate)
            let timeForString = self.itsTimeWithTime(date: taskDate)
            let title = goodTimeOfDayString
            let body = "\(timeForString). Time to go and take your pills."
            return NotificationText(title: title, body: body)
        case .verification:
            let title = "Hi there! i’ve noticed you opened your pill box."
            let body = "Are you taking your pills right now?"
            return NotificationText(title: title, body: body)
        case .done:
            return NotificationText(title: "Taking pills marked as done.", body: "")
        }
    }

    func food(localNotificationCategory: LocalNotificationCategotry, taskDate: Date)->NotificationText {
        switch localNotificationCategory {
        case .warning:
            let title = "You have already made dinner today!"
            let body = "Are you sure you want to do that again?"
            return NotificationText(title: title, body: body)
        case .notification:
            let goodTimeOfDayString = self.goodTimeOfDayString(date: taskDate)
            let timeForString = self.itsTimeWithTime(date: taskDate)
            let title = goodTimeOfDayString
            let body = "\(timeForString). Time to make dinner."
            return NotificationText(title: title, body: body)
        case .verification:
            let title = "Hey there!  I’ve noticed you opened your fridge"
            let body = "Are you making dinner?"
            return NotificationText(title: title, body: body)
        case .done:
            return NotificationText(title: "Making dinner marked as done.", body: "")
        }
    }

    func goodTimeOfDayString(date: Date)->String {
        let goodTimeOfDayString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpGoodTimeOfDay"), date.dateToDayPartDeifinisionString())
        return goodTimeOfDayString
    }
    
    func itsTimeWithTime(date: Date)->String {
        let timeForString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpItsTimeWithTime"), date.toStringCurrentRegionShortTime())
        return timeForString
    }
}
