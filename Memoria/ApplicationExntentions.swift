//
//  ApplicationExntentions.swift
//  Memoria
//
//  Created by Matan Cohen on 09/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    static var bacgkroundTaskIdentifer: UIBackgroundTaskIdentifier?
    static func isApplicationActive()->Bool {
        return UIApplication.shared.applicationState == UIApplicationState.active
    }
    
    static func showLocalNotification(text: String) {
        let notification = UILocalNotification()
        notification.alertBody = text
            notification.soundName = UILocalNotificationDefaultSoundName;
        UIApplication.shared.presentLocalNotificationNow(notification)
    }
    
    static func beginBackgroundTask() {
//        if let isBackgroundTaskIdentifer = UIApplication.bacgkroundTaskIdentifer {
//            UIApplication.shared.endBackgroundTask(isBackgroundTaskIdentifer)
//        }
//        self.bacgkroundTaskIdentifer = UIApplication.shared.beginBackgroundTask(expirationHandler: {
//        })
    }
}
