//
//  TasksNotificationsPresenter.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import Swinject


class TasksNotificationsPresenter : NSObject {
    let tasksServices : TasksServices
    let iBeaconServices : IBeaconServices
    let recorder : VoiceRecorder
    let reminderPopUp = ReminderPopUp()
    let container : Container
    
    init(tasksServices : TasksServices, iBeaconServices : IBeaconServices, container : Container) {
        self.tasksServices = tasksServices
        self.iBeaconServices = iBeaconServices
        self.recorder = VoiceRecorder()
        self.container = container
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskNotification(_:)), name: NSNotification.Name(rawValue: NotificationsNames.kPresentTaskNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskVerification(_:)), name: NSNotification.Name(rawValue: NotificationsNames.kPresentTaskVerification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskWarning(_:)), name: NSNotification.Name(rawValue: NotificationsNames.kPresentTaskWarning), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TasksNotificationsPresenter.presentTaskMarkedAsDone(_:)), name: NSNotification.Name(rawValue: NotificationsNames.kPresentTaskMarkedAsDone), object: nil)
    }
    
    //MARK: Public
    
    internal func presentTaskMarkedAsDone(_ notification : Notification) {
        let task = notification.object as? Task
        let text = "Task has marked as done"
        let cancelButton = ButtonAction(title: "Ok", handler: { (ButtonAction) -> Void in
            self.iBeaconServices.isBeaconInErea(task!.taskBeaconIdentifier!, handler: { (result) -> Void in})
        })
        reminderPopUp.presentPopUp(task!.taskType.name(), message: text, cancelButton: cancelButton, buttons: nil, completion: { () -> Void in})
        LocalNotificationPresenter.showLocalNotification(title: "Task was marked as done", subtitle: "Task name: \(task?.taskType.name)", body: "Tap to open", localNotificationCategory: LocalNotificationCategotry.done)
    }
    
    internal func presentTaskNotification(_ notification : Notification) {
        let task = notification.object as? Task
        let notificationPopUp = self.container.resolve(TaskNotificationPopUp.self, argument: task!)
        let mainViewController = UIApplication.shared.keyWindow?.rootViewController
        mainViewController?.present(notificationPopUp!, animated: true, completion: nil)
        
        let currentDate = Date()
        let userName = Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpUserName")
        let goodTimeOfDatString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpGoodTimeOfDay"), (task?.taskTime!.dateToDayPartDeifinisionString())!, userName)
        let timeForString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpItsTimeFor"), currentDate.toStringCurrentRegionShortTime(), (task?.taskType.name)!())
        
        LocalNotificationPresenter.showLocalNotification(title: "Notification", subtitle: (task?.taskType.name())!, body: goodTimeOfDatString + " " + timeForString, localNotificationCategory: LocalNotificationCategotry.notification)
    }

    internal func presentTaskVerification(_ notification : Notification) {
        let task = notification.object as? Task
        let notificationPopUp = self.container.resolve(TaskVerificationPopUp.self, argument: task!)
        let mainViewController = UIApplication.shared.keyWindow?.rootViewController
        mainViewController?.present(notificationPopUp!, animated: true, completion: nil)
        
        let iSeeYourNear = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpISeeYourNeer"), (task?.taskType.name)!())
        let didYouYet = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskVerificationPopUpDidYouYet"), (task?.taskType.name)!())
        LocalNotificationPresenter.showLocalNotification(title: "Verification", subtitle: (task?.taskType.name())!, body: iSeeYourNear + " " + didYouYet, localNotificationCategory: LocalNotificationCategotry.verification)
    }

    internal func presentTaskWarning(_ notification : Notification) {
        let task = notification.object as! Task
        let notificationPopUp = self.container.resolve(TaskWarningPopUp.self, argument: task)
        let mainViewController = UIApplication.shared.keyWindow?.rootViewController
        mainViewController?.present(notificationPopUp!, animated: true, completion: nil)
        
        let didAllreadyString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidAllready"), task.taskType.name())
        let laterTodayString = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidLaterToday"), task.taskType.name())
        let warningString = (task.taskTime! <= Date()) ? didAllreadyString : laterTodayString
        
        let didAllreadyStringBecareful = Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidCerfulNotToTakeTwice")
        let laterTodayStringBecareful = String.localizedStringWithFormat(Content.getContent(ContentType.labelTxt, name: "TaskWarningPopUpDidPleaseWaitFor"), task.taskTime!.toStringCurrentRegionShortTime())
        let beCarefulString = (task.taskTime! <= Date()) ? didAllreadyStringBecareful : laterTodayStringBecareful
        
        LocalNotificationPresenter.showLocalNotification(title: "Warning", subtitle: task.taskType.name(), body: warningString + " " + beCarefulString, localNotificationCategory: LocalNotificationCategotry.warning)
    }

}
