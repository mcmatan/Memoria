//
//  TasksDB.swift
//  KontactTest
//
//  Created by Matan Cohen on 1/16/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//



import Foundation
import FirebaseDatabase

class TasksDB {
    var tasksByUid = [String : Task]()
    let fireBaseCoreWrapper: FireBaseCoreWrapper
    let ref: FIRDatabaseReference
    let tasksRef: FIRDatabaseReference
    let currentUserContext: CurrentUserContext
    
    init(fireBaseCoreWrapper: FireBaseCoreWrapper,
         currentUserContext: CurrentUserContext) {
        self.fireBaseCoreWrapper = fireBaseCoreWrapper
        self.currentUserContext = currentUserContext
        FIRDatabase.database().persistenceEnabled = true
        let user = self.currentUserContext.getCurrentUser()
        self.ref = FIRDatabase.database().reference().child("users").child(user.uid)
        self.tasksRef = self.ref.child("tasks")
        
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
