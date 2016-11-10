//
//  LocalNotificationCategotry.swift
//  Memoria
//
//  Created by Matan Cohen on 05/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

enum LocalNotificationCategotry: String {
    case notification = "notification"
    case warning = "warning"
    case verification = "verification"
    case done = "done"
    
    static func allValus()-> [LocalNotificationCategotry] {
        return [LocalNotificationCategotry.notification, LocalNotificationCategotry.warning, LocalNotificationCategotry.verification, LocalNotificationCategotry.done]
    }
    
//    func image()->UIImage {
//        switch self {
//            case .notification
//                return UIImage(named: <#T##String#>)
//        }
//    }
}

enum TaskType: String {
    case brushTeeth = "brushTeeth"
    case food = "food"
    case drugs = "drugs"
    
    static func getAllValus()-> [TaskType] {return [TaskType.brushTeeth, TaskType.food, TaskType.drugs]}
    
    func name()->String {
        switch self {
        case .brushTeeth:
            return "Brush your teeth"
        case .food:
            return "Eat food"
        case .drugs:
            return "Take your pills"
        }
    }
    
    init(typeString: String) {
        switch typeString {
        case TaskType.brushTeeth.rawValue:
            self = .brushTeeth
        case TaskType.food.rawValue:
            self = .food
        case TaskType.drugs.rawValue:
            self = .drugs
        default:
            print("No maching Task type string!")
            self = .drugs
        }
    }
    
    func soundURL(localNotificationCategotry: LocalNotificationCategotry)->URL {
        switch localNotificationCategotry {
        case .notification:
            let url = Bundle.main.url(forResource: "drugs-notification", withExtension: "aiff")
            return url!
        case .warning:
            let url = Bundle.main.url(forResource: "drugs-warning", withExtension: "aiff")
            return url!
        case .verification:
            let url = Bundle.main.url(forResource: "drugs-verification", withExtension: "aiff")
            return url!
        case .done:
            let url = Bundle.main.url(forResource: "drugs-done", withExtension: "aiff")
            return url!
        }
    }

    func imageURL(localNotificationCategory: LocalNotificationCategotry)->URL {
        
        let color = self.colorLocalNotificationType(localNotificationType: localNotificationCategory)
        
        switch self {
        case .brushTeeth:
            let url = Bundle.main.url(forResource: "brushTeeth\(color)", withExtension: "png")
            return url!
        case .drugs:
            let url = Bundle.main.url(forResource: "drugs\(color)", withExtension: "png")
            return url!
        case .food:
            let url = Bundle.main.url(forResource: "food\(color)", withExtension: "png")
            return url!
        }
    }
    
    func colorLocalNotificationType(localNotificationType: LocalNotificationCategotry)->String {
        switch localNotificationType {
        case .done:
            return ""
        case .notification:
            return "Blue"
        case .verification:
            return "Green"
        case .warning:
            return "Red"
        }
    }
}

