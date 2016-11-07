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
            let url = Bundle.main.url(forResource: "pillsNotification", withExtension: "aiff")
            return url!
        case .warning:
            let url = Bundle.main.url(forResource: "pillsWarning", withExtension: "aiff")
            return url!
        case .verification:
            let url = Bundle.main.url(forResource: "pillsVerification", withExtension: "aiff")
            return url!
        default:
            print("No maching notification category!")
            let url = Bundle.main.url(forResource: "pillsVerification", withExtension: "aiff")
            return url!
        }
    }

    func imageURL()->URL {
        switch self {
        case .brushTeeth:
            let url = Bundle.main.url(forResource: "brushTeeth", withExtension: "png")
            return url!
        case .drugs:
            let url = Bundle.main.url(forResource: "drugs", withExtension: "png")
            return url!
        case .food:
            let url = Bundle.main.url(forResource: "food", withExtension: "png")
            return url!
        }
    }
}

