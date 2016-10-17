//
//  IBeaconCloud.swift
//  Memoria
//
//  Created by Matan Cohen on 17/10/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

protocol IBeaconCloudType {
 func getColorFor(beaconIdentifier: IBeaconIdentifier)->UIColor
}

enum ColorForIBeaconIdentifier {
    case Lemon
    case Beetroot
    case Candy
    case Nun
    
    static func fromMajor(major: String)->ColorForIBeaconIdentifier {
        switch major {
        case "58227":
            return .Lemon
        case "5487":
            return .Beetroot
        case "17042":
            return .Candy
        default:
            return .Nun
        }
    }
    
    func color()->UIColor {
        switch self {
        case .Lemon:
            return UIColor(red: 243.0/255.0, green: 224.0/255.0, blue: 0.0/255.0, alpha: 1)
        case .Beetroot:
            return UIColor(red: 113.0/255.0, green: 47.0/255.0, blue: 71.0/255.0, alpha: 1)
        case .Candy:
            return UIColor(red: 246.0/255.0, green: 190.0/255.0, blue: 214.0/255.0, alpha: 1)
        default:
            return UIColor.black
        }
    }
}

class IBeaconCloud: IBeaconCloudType {
    
    func getColorFor(beaconIdentifier: IBeaconIdentifier)->UIColor {
        let colorForBeaconIdentifer = ColorForIBeaconIdentifier.fromMajor(major: beaconIdentifier.major)
        return colorForBeaconIdentifer.color()
    }
}
