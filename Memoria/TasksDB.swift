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
    var tasksByNearableIdentifer = [String : Task]()
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
    }
    

    func getTaskForNearableIdentifer(_ nearableIdentifer : String) ->Task? {
        return self.tasksByNearableIdentifer[nearableIdentifer]
    }
    
    func saveTask(_ task : Task) {
        self.tasksRef.child(task.uid).setValue(task.toAnyObject())
    }
    
    func removeTask(_ task : Task) {
        self.tasksRef.child(task.uid).removeValue()
    }
    
    func getAllTasks()->[Task] {
        return Array(self.tasksByNearableIdentifer.values)
    }
    
    func isThereTaskForNearableIdentifier(_ nearableIdentifer : String)->Bool {
        if let _ = self.tasksByNearableIdentifer[nearableIdentifer] {
            return true
        } else {
            return false
        }
    }
    
    func startListeningForChanges() {
        
        self.tasksRef.observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            self.tasksByNearableIdentifer = [String : Task]()
            for tasksDic in postDict.values {
                let task = Task(dic: tasksDic as! Dictionary<String, Any>)
                self.tasksByNearableIdentifer[task.uid] = task
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
