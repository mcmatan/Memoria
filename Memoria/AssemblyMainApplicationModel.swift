

import Foundation
import Swinject

open class AssemblyMainApplicationModel {
    
    class func run(_ loginContainer: Container, mainApplicationContainer: Container) {
        
        mainApplicationContainer.register(CurrenctTaskCreator.self) { c in
            return CurrenctTaskCreator()
            }.inObjectScope(ObjectScope.container)

        
        mainApplicationContainer.register(TasksDB.self) { c in
            return TasksDB(
                currentUserContext: loginContainer.resolve(CurrentUserContext.self)!
            )
            }.inObjectScope(ObjectScope.container)
        
        mainApplicationContainer.register(NearableStriggerManager.self) { c in
            return NearableStriggerManager(
                tasksDB: mainApplicationContainer.resolve(TasksDB.self)!)
            }.inObjectScope(ObjectScope.container)
        
        mainApplicationContainer.register(NearableLocator.self) { c in
            return NearableLocator()
            }.inObjectScope(ObjectScope.container)

        mainApplicationContainer.register(NearableServices.self) { c in
            return NearableServices(nearableLocator: mainApplicationContainer.resolve(NearableLocator.self)!,
                                   tasksDB:mainApplicationContainer.resolve(TasksDB.self)!)
        }.inObjectScope(ObjectScope.container)
        
        mainApplicationContainer.register(NotificationScheduler.self) { c in
            return NotificationScheduler()
            }.inObjectScope(ObjectScope.container)
        
        mainApplicationContainer.register(TasksServices.self) { c in
            return TasksServices(tasksDB: mainApplicationContainer.resolve(TasksDB.self)!,
                nearableStriggerManager: mainApplicationContainer.resolve(NearableStriggerManager.self)!,
                notificationScheduler: mainApplicationContainer.resolve(NotificationScheduler.self)!
            )
        }.inObjectScope(ObjectScope.container)
        
        mainApplicationContainer.register(TaskActionsPerformer.self) { c in
            return TaskActionsPerformer(
                taskServices: mainApplicationContainer.resolve(TasksServices.self)!)
            }.inObjectScope(ObjectScope.container)
        let _ = mainApplicationContainer.resolve(TaskActionsPerformer.self)
    
        mainApplicationContainer.register(NotificationSync.self) { c in
            return NotificationSync(
                notificationScheduler: mainApplicationContainer.resolve(NotificationScheduler.self)!,
                tasksDB: mainApplicationContainer.resolve(TasksDB.self)!
                )
        }.inObjectScope(.container)
        let _ = mainApplicationContainer.resolve(NotificationSync.self)
        
        mainApplicationContainer.register(RefreshEventEmitter.self) { c in
            return RefreshEventEmitter()
        }.inObjectScope(ObjectScope.container)
        let _ = mainApplicationContainer.resolve(RefreshEventEmitter.self)
    }
    
}
