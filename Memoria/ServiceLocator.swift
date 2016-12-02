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
    static var mainApplicationContainer = Container()
    static var loginContainer = Container()
    
    static func locate<Service>(_ serviceType: Service.Type) -> Service?
    {
        if let isLocated = self.loginContainer.resolve(serviceType) {
            return isLocated
        }
        
        return self.mainApplicationContainer.resolve(serviceType) 
    }
        
}
