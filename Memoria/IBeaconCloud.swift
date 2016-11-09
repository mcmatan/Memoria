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
    func getColorFor(nearableIdentifer: String)->UIColor
}

struct NearbleColors {
    static let perpule = UIColor(red: 73.0/255.0, green: 63.0/255.0, blue: 152.0/255.0, alpha: 1)
    static let lightBlue = UIColor(red: 143.0/255.0, green: 210.0/255.0, blue: 247.0/255.0, alpha: 1)
    static let pink = UIColor(red: 240.0/255.0, green: 130.0/255.0, blue: 179.0/255.0, alpha: 1)
    static let lightGreen = UIColor(red: 142.0/255.0, green: 197.0/255.0, blue: 157.0/255.0, alpha: 1)
    static let yellow = UIColor(red: 193.0/255.0, green: 190.0/255.0, blue: 10.0/255.0, alpha: 1)
    
    static func getColorFor(nearableIdentifer: String)->UIColor {
        switch nearableIdentifer {
        case "d886be9f04ca4a3b":
            return NearbleColors.perpule
        case "1160295d91075eaa":
            return NearbleColors.perpule
        case "66dca145bccee801":
            return NearbleColors.perpule
        case "b56617d88f702942":
            return NearbleColors.lightBlue
        case "79a5e664f02beff6":
            return NearbleColors.pink
        case "c720d7e9e2808c5d":
            return NearbleColors.lightGreen
        case "c7a5b1e662a5e798":
            return NearbleColors.lightGreen
        case "f1796cdd42911c9c":
            return NearbleColors.pink
        case "4338e96fc7711be0":
            return NearbleColors.yellow
        case "b9240b46784d9e8f":
            return NearbleColors.lightGreen
        default:
            return UIColor.black
        }
    }
}

class IBeaconCloud: IBeaconCloudType {
    func getColorFor(nearableIdentifer: String)->UIColor {
        return NearbleColors.getColorFor(nearableIdentifer: nearableIdentifer)
    }
}
