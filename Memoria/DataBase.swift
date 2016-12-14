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

class DataBase {
    var tasksByUid = [String : Task]()
    let ref: FIRDatabaseReference
    let tasksRef: FIRDatabaseReference
    let locationRef: FIRDatabaseReference
    let currentUserContext: CurrentUserContext
    
    init(
         currentUserContext: CurrentUserContext) {
        self.currentUserContext = currentUserContext
        let user = self.currentUserContext.getCurrentUser()
        self.ref = FIRDatabase.database().reference().child("users").child(user.uid)
        self.tasksRef = self.ref.child("tasks")
        self.locationRef = self.ref.child("location")
        
        self.writeConnection()
        self.startListeningForChanges()
        self.writeEmail()
    }
    
    func writeEmail() {
        let emailRef = self.ref.child("email")
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
