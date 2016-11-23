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
import EmitterKit


class TasksNotificationsPresenter : NSObject {
    let iNearableServices : NearableServices
    let recorder : VoiceRecorder
    let reminderPopUp = ReminderPopUp()
    let container : Container
    let notificationScheduler: NotificationScheduler
    let mainApplicationViewController: UIViewController
    
    var presentTaskNotificationListener: EventListener<Task>?
    
    init(iNearableServices : NearableServices,
         container : Container,
         notificationScheduler: NotificationScheduler,
         mainApplicationViewController: UIViewController
        ) {
        self.mainApplicationViewController = mainApplicationViewController
        self.iNearableServices = iNearableServices
        self.recorder = VoiceRecorder()
        self.container = container
        self.notificationScheduler = notificationScheduler
        super.init()

        self.presentTaskNotificationListener = Events.shared.presentTaskNotification.on({ task in
            self.presentTaskNotification(task: task, playSound: UIApplication.isActive())
        })
        
    }
    
    //Notification

    internal func presentTaskNotification(task: Task, playSound: Bool) {
        if (UIApplication.isInBackground() == true) {
            self.notificationScheduler.squeduleNotification(task: task)
        }else {
            let notificationPopUp = self.container.resolve(TaskNotificationPopUp.self, argument: task)
            self.presentOnMainView(viewController: notificationPopUp!)
        }
        
        if playSound {
            self.playSoundForTask(task: task)
        }
    }
    
    func playSoundForTask(task: Task) {
        Events.shared.playSound.emit(task)
    }
    
    func presentOnMainView(viewController: UIViewController) {
        let mainViewController = self.mainApplicationViewController
        if let isPresentedViewController = mainViewController.presentedViewController {
            isPresentedViewController.dismiss(animated: false, completion: { 
                mainViewController.present(viewController, animated: true, completion: nil)
            })
        }else {
            mainViewController.present(viewController, animated: true, completion: nil)
        }
    }

}
