//
//  NearableServices.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/14/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class NearableServices {
    var nearableLocator : NearableLocator
    var dataBase : DataBase
    
    init(nearableLocator : NearableLocator, dataBase : DataBase) {
        self.nearableLocator = nearableLocator
        self.dataBase = dataBase
    }
    
    func isThereNearableInErea(_ handler: (( _ result : Bool, _ nearable : ESTNearable?) -> Void)!) {
        nearableLocator.getClosestNearable({ nearable in
            if let _ = nearable {
                handler(true, nearable)
            } else {
                handler(false, nearable)
            }
        })
    }
    
    func isNearableAlreadyHasATaskAssigned(_ nearable :ESTNearable)->Bool {
        return false
        //return self.dataBase.isThereTaskForNearableIdentifier(nearable.identifier)
    }
    
    func getNearableColorFor(nearableIdentifer :String)->UIColor {
        return NearbleColors.getColorFor(nearableIdentifer: nearableIdentifer)
    }
}
