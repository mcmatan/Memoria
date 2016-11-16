//
//  ServiceLocator.swift
//  Memoria
//
//  Created by Matan Cohen on 16/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import Swinject

class ServiceLocator {
    static var container: Container!
    
    static func locate<Service>(_ serviceType: Service.Type) -> Service?
    {
        return ServiceLocator.container.resolve(serviceType)
    }
}
