//
//  DataBase.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//



import Foundation
import FirebaseDatabase

let LOCATION_UPDATE_TIME = "updateTime"
let LOCATION_LAT = "lat"
let LOCATION_LON = "lon"

let USERS_REF = "users"
let TASKS_REF = "tasks"
let LOCATION_REF = "location"
let LAST_ACTIVE_REF = "lastActive"
let EMAIL_REF = "email"


class DataBase: NSObject {
    var tasksByUid = [String : Task]()
    let ref: FIRDatabaseReference
    let tasksRef: FIRDatabaseReference
    let locationRef: FIRDatabaseReference
    let lastActiveRef: FIRDatabaseReference
    let currentUserContext: CurrentUserContext
    
    init(
         currentUserContext: CurrentUserContext) {
        self.currentUserContext = currentUserContext
        let user = self.currentUserContext.getCurrentUser()
        self.ref = FIRDatabase.database().reference().child(USERS_REF).child(user.uid)
        self.tasksRef = self.ref.child(TASKS_REF)
        self.locationRef = self.ref.child(LOCATION_REF)
        self.lastActiveRef = self.ref.child(LAST_ACTIVE_REF)
    
        super.init()
        self.writeConnection()
        self.startListeningForChanges()
        self.writeEmail()
        NotificationCenter.default.addObserver(self, selector:#selector(writeStateApplicationBecomeActive) , name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    deinit {
          NotificationCenter.default.removeObserver(self)
    }
    
    func writeEmail() {
        let emailRef = self.ref.child(EMAIL_REF)
        emailRef.setValue(self.currentUserContext.getCurrentUser().email)
    }
    
    func getTask(taskUid: String)->Task? {
        return self.tasksByUid[taskUid]
    }
    
    func saveTask(_ task : Task) {
        self.tasksRef.child(task.uid).setValue(task.toAnyObject())
    }
    
    func removeTask(_ task : Task) {
        self.tasksRef.child(task.uid).removeValue()
    }
    
    func saveLocation(lat: String, lon: String) {
        
        let nowDate = Date()
        let timeIntervalSince70 = String(nowDate.timeIntervalSince1970)
        let dic = [LOCATION_LAT : lat, LOCATION_LON: lon, LOCATION_UPDATE_TIME: timeIntervalSince70];
        self.locationRef.setValue(dic);
    }
    
    func getAllTasks()->[Task] {
        return Array(self.tasksByUid.values)
    }
    
    func writeStateApplicationBecomeActive() {
        let nowDate = Date()
        let timeIntervalSince70 = String(nowDate.timeIntervalSince1970)
        self.lastActiveRef.setValue(timeIntervalSince70)
    }
    
    
    func startListeningForChanges() {
        
        self.tasksRef.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            self.tasksByUid = [String : Task]()
            for tasksDic in postDict.values {
                let task = Task(dic: tasksDic as! Dictionary<String, Any>)
                self.tasksByUid[task.uid] = task
            }
            
            Events.shared.tasksChanged.emit(())
        })
    }
    
    private func writeConnection() {
        let uid = self.currentUserContext.getCurrentUser().uid
        let email = self.currentUserContext.getCurrentUser().email
        let usersRef = FIRDatabase.database().reference(withPath: "online")
        let currentUserRef = usersRef.child(uid)
        currentUserRef.setValue(email)
        currentUserRef.onDisconnectRemoveValue()
    }
    
}
