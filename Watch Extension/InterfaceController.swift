//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Matan Cohen on 05/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            
            let content = UNMutableNotificationContent()
            content.title = "The Code Ninja says"
            content.body = "The new notifications api in iOS 10 is just awesome"
            content.subtitle = "Also you can add a subtitle with it"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let requestIdentifier = "TheCodeNinja_Identifier"
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content,trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let isError = error {
                    print("Error on notification reuqest = \(isError)")
                }
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
