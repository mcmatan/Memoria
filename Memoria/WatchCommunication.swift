//
//  WatchCommunication.swift
//  Memoria
//
//  Created by Matan Cohen on 05/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol WatchCommunicationType {
    
}

class WatchCommunication: NSObject, WCSessionDelegate, WatchCommunicationType {
    var session: WCSession? = nil
    var timer: Timer!
    override init() {
        super.init()
        if WCSession.isSupported() {
            self.session = WCSession.default()
            self.session?.delegate = self
            self.session?.activate()
        } else {
            print("Watch not supported!")
        }
        
//        self.sendSomeData()
//        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendSomeData), userInfo: nil, repeats: true)
    }
    
    func sendSomeData() {
        let message = ["ShowImage": "ShowImage"]
        self.session?.sendMessage(message, replyHandler: nil, errorHandler: { error in
            print("Did faile to send watch message, error = \(error.localizedDescription)")
        })
    }
    
    //WCSessionDelegate
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation state = \(activationState)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        
    }

}
