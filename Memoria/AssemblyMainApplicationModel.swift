

import Foundation
import Swinject

open class AssemblyMainApplicationModel {
    
    class func run(_ container : Container) {
        
        container.register(TasksDB.self) { c in
            return TasksDB()
            }.inObjectScope(ObjectScope.container)
        
        container.register(NearableStriggerManager.self) { c in
            return NearableStriggerManager(
                tasksDB: container.resolve(TasksDB.self)!)
            }.inObjectScope(ObjectScope.container)
        
        container.register(NearableLocator.self) { c in
            return NearableLocator()
            }.inObjectScope(ObjectScope.container)

        container.register(NearableServices.self) { c in
            return NearableServices(nearableLocator: container.resolve(NearableLocator.self)!,
                                   tasksDB:container.resolve(TasksDB.self)!)
        }.inObjectScope(ObjectScope.container)
        
        container.register(TaskNotificationsTracker.self) { c in
            return TaskNotificationsTracker(
                taskDB: container.resolve(TasksDB.self)!,
                nearableStriggerManager: container.resolve(NearableStriggerManager.self)!)
            }.inObjectScope(ObjectScope.container)
        let _ = container.resolve(TaskNotificationsTracker.self)
        
        container.register(LocalNotificationScheduler.self) { c in
            return LocalNotificationScheduler()
            }.inObjectScope(ObjectScope.container)

        container.register(TasksServices.self) { c in
            return TasksServices(tasksDB: container.resolve(TasksDB.self)!,
                taskNotificationsTracker: container.resolve(TaskNotificationsTracker.self)!,
                nearableStriggerManager: container.resolve(NearableStriggerManager.self)!,
                localNotificationScheduler: container.resolve(LocalNotificationScheduler.self)!
            )
        }.inObjectScope(ObjectScope.container)

        container.register(CurrenctTaskCreator.self) { c in
            return CurrenctTaskCreator()
            }.inObjectScope(ObjectScope.container)
        
        container.register(TestingNotifications.self) { c in
            return TestingNotifications(
                localNotificationScheduler: container.resolve(LocalNotificationScheduler.self)!
            )
            }.inObjectScope(ObjectScope.container)
        let _ = container.resolve(TestingNotifications.self)
        
        container.register(TaskActionsPerformer.self) { c in
            return TaskActionsPerformer(
                taskServices: container.resolve(TasksServices.self)!)
            }.inObjectScope(ObjectScope.container)
        let _ = container.resolve(TaskActionsPerformer.self)
        
    }
    
}
