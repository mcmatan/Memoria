

import Foundation
import Swinject

open class AssemblyModel {
    
    class func run(_ container : Container) {
        
        container.register(IbeaconsTracker.self) { c in
            let ibeaconLocationFinder = IbeaconsTracker()
            return ibeaconLocationFinder
        }.inObjectScope(ObjectScope.container)

        container.register(TasksDB.self) { c in
            return TasksDB()
        }.inObjectScope(ObjectScope.container)
        
        container.register(IBeaconCloudType.self) { c in
            return IBeaconCloud()
            }.inObjectScope(ObjectScope.container)

        container.register(IBeaconServices.self) { c in
            return IBeaconServices(ibeaconLocationFinder: container.resolve(IbeaconsTracker.self)!,
                                   tasksDB:container.resolve(TasksDB.self)!,
            beaconCloud:container.resolve(IBeaconCloudType.self)!)
        }.inObjectScope(ObjectScope.container)

        container.register(TasksServices.self) { c in
            return TasksServices(tasksDB: container.resolve(TasksDB.self)!,
                scheduler: container.resolve(NotificationScheduler.self)!,
                taskNotificationsTracker: container.resolve(TaskNotificationsTracker.self)!,
                beaconTracker: container.resolve(IbeaconsTracker.self)!
            )
        }.inObjectScope(ObjectScope.container)

        container.register(CurrenctTaskCreator.self) { c in
            return CurrenctTaskCreator()
            }.inObjectScope(ObjectScope.container)
        
        container.register(NotificationExecuter.self) { c in
            return NotificationExecuter(
                tasksDB: container.resolve(TasksDB.self)!)
            }.inObjectScope(ObjectScope.container)

        container.register(NotificationScheduler.self) { c in
            return NotificationScheduler()
            }.inObjectScope(ObjectScope.container)
        
        
        container.register(WatchCommunicationType.self) { c in
            return WatchCommunication()
            }.inObjectScope(ObjectScope.container)
        let _ = container.resolve(WatchCommunicationType.self)
        
        container.register(TaskNotificationsTracker.self) { c in
            return TaskNotificationsTracker(
                taskDB: container.resolve(TasksDB.self)!,
                scheduler: container.resolve(NotificationScheduler.self)!,
                ibeaconsTracker: container.resolve(IbeaconsTracker.self)!,
            notificationExecuter: container.resolve(NotificationExecuter.self)!)
            }.inObjectScope(ObjectScope.container)
         let _ = container.resolve(TaskNotificationsTracker.self)

    }
    
}
