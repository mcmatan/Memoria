//
//  IOSCommunication.swift
//  Memoria
//
//  Created by Matan Cohen on 05/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import WatchConnectivity

class IOSCommunication:NSObject, WCSessionDelegate {
    var session: WCSession? = nil
    override init() {
        super.init()
        if WCSession.isSupported() {
            self.session = WCSession.default()
            self.session?.delegate = self
            self.session?.activate()
        } else {
            print("Watch not supported!")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
     print("Activation state = \(activationState)")
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Did get message!! this is the message = \(message)")
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void) {
        
        replyHandler(["Got it": "Got it"])
        print("Did get message!! this is the message = \(message)")
    }

    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        print("Did get message!!")
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Swift.Void) {
        print("Did get message!!")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
    }
    
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
    }
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        
    }

}
