

import Foundation
import Swinject

open class AssemblyMainApplicationModel {
    
    class func run(_ container : Container) {
        
        container.register(TasksDB.self) { c in
            return TasksDB(
                fireBaseCoreWrapper: container.resolve(FireBaseCoreWrapper.self)!,
                currentUserContext: container.resolve(CurrentUserContext.self)!
            )
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
        
        container.register(NotificationScheduler.self) { c in
            return NotificationScheduler()
            }.inObjectScope(ObjectScope.container)
        
        container.register(NotificationSync.self) { c in
            return NotificationSync(taskDB: container.resolve(TasksDB.self)!,
                                    notificationScheduler: container.resolve(NotificationScheduler.self)!
            )
            }.inObjectScope(.container)

        container.register(TasksServices.self) { c in
            return TasksServices(tasksDB: container.resolve(TasksDB.self)!,
                nearableStriggerManager: container.resolve(NearableStriggerManager.self)!,
                notificationScheduler: container.resolve(NotificationScheduler.self)!,
                notificationSync: container.resolve(NotificationSync.self)!
            )
        }.inObjectScope(ObjectScope.container)

        container.register(CurrenctTaskCreator.self) { c in
            return CurrenctTaskCreator()
            }.inObjectScope(ObjectScope.container)
        
        container.register(TaskActionsPerformer.self) { c in
            return TaskActionsPerformer(
                taskServices: container.resolve(TasksServices.self)!)
            }.inObjectScope(ObjectScope.container)
        let _ = container.resolve(TaskActionsPerformer.self)
    
        container.register(NotificationSync.self) { c in
            return NotificationSync(
                taskDB: container.resolve(TasksDB.self)!, notificationScheduler: container.resolve(NotificationScheduler.self)!)
        }.inObjectScope(.container)
        let _ = container.resolve(NotificationSync.self)
    }
    
}
