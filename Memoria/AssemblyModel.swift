

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

        container.register(IBeaconServices.self) { c in
            return IBeaconServices(ibeaconLocationFinder: container.resolve(IbeaconsTracker.self)!, tasksDB:
            container.resolve(TasksDB.self)!)
        }.inObjectScope(ObjectScope.container)

        container.register(TasksServices.self) { c in
            return TasksServices(tasksDB: container.resolve(TasksDB.self)!,
                scheduler: container.resolve(Scheduler.self)!,
                taskNotificationsTracker: container.resolve(TaskNotificationsTracker.self)!
            )
        }.inObjectScope(ObjectScope.container)

        container.register(CurrenctTaskCreator.self) { c in
            return CurrenctTaskCreator()
            }.inObjectScope(ObjectScope.container)

        container.register(Scheduler.self) { c in
            return Scheduler(
                tasksDB: container.resolve(TasksDB.self)!)
            }.inObjectScope(ObjectScope.container)
        
        container.register(TaskNotificationsTracker.self) { c in
            return TaskNotificationsTracker(
                taskDB: container.resolve(TasksDB.self)!,
                scheduler: container.resolve(Scheduler.self)!,
                ibeaconsTracker: container.resolve(IbeaconsTracker.self)!)
            }.inObjectScope(ObjectScope.container)
         container.resolve(TaskNotificationsTracker.self)
        
        container.register(IBeaconWrapper.self) { c in
            return IBeaconWrapper()
            }.inObjectScope(ObjectScope.container)
        let _ = container.resolve(IBeaconWrapper.self)

    }
    
}
