//
//  LocalNotificationCategotry.swift
//  Memoria
//
//  Created by Matan Cohen on 05/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

enum TaskType: String {
    case brushTeeth = "brushTeeth"
    case food = "food"
    case drugs = "drugs"
    case goToWork = "goToWork"
    case goToGym = "goToGym"
    case wakeUp = "wakeUp"
    
    static func getAllValus()-> [TaskType] {return [TaskType.brushTeeth, TaskType.food, TaskType.drugs]}
    
    func name()->String {
        switch self {
        case .brushTeeth:
            return "Brush your teeth"
        case .food:
            return "Eat food"
        case .drugs:
            return "Take your pills"
        case .goToWork:
            return "Go to work"
        case .goToGym:
            return "Go to the GYM"
        case .wakeUp:
            return "Wake up"
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
        case TaskType.goToGym.rawValue:
            self = .goToGym
        case TaskType.goToWork.rawValue:
            self = .goToWork
        case TaskType.wakeUp.rawValue:
            self = .wakeUp
        default:
            self = .wakeUp
        }
    }
    
    func soundURL()->URL {
        let taskTypeString = self.rawValue
        let url = Bundle.main.url(forResource: "\(taskTypeString)-notification", withExtension: "aiff")
        return url!
    }

    func imageURL()->URL {
        let color = "blue"

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
            case .goToWork:
                let url = Bundle.main.url(forResource: "goToWork\(color)", withExtension: "png")
                return url!
            case .goToGym:
                let url = Bundle.main.url(forResource: "goToGym\(color)", withExtension: "png")
                return url!
            case .wakeUp:
                let url = Bundle.main.url(forResource: "wakeUp\(color)", withExtension: "png")
                return url!
            }
    }

}

