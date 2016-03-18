

import Foundation
import Swinject

public class AssemblyModel {
    
    class func run(container : Container) {
        
        container.register(IbeaconsTracker.self) { c in
            let ibeaconLocationFinder = IbeaconsTracker()
            return ibeaconLocationFinder
        }.inObjectScope(.Container)

        container.register(TasksDB.self) { c in
            return TasksDB()
        }.inObjectScope(.Container)

        container.register(IBeaconServices.self) { c in
            return IBeaconServices(ibeaconLocationFinder: container.resolve(IbeaconsTracker.self)!, tasksDB:
            container.resolve(TasksDB.self)!)
        }.inObjectScope(.Container)

        container.register(TasksServices.self) { c in
            return TasksServices(tasksDB: container.resolve(TasksDB.self)!,
                scheduler: container.resolve(Scheduler.self)!,
                taskNotificationsTracker: container.resolve(TaskNotificationsTracker.self)!
            )
        }.inObjectScope(.Container)

        container.register(CurrenctTaskCreator.self) { c in
            return CurrenctTaskCreator()
            }.inObjectScope(.Container)

        container.register(Scheduler.self) { c in
            return Scheduler(
                tasksDB: container.resolve(TasksDB.self)!)
            }.inObjectScope(.Container)
        
        container.register(TaskNotificationsTracker.self) { c in
            return TaskNotificationsTracker(
                taskDB: container.resolve(TasksDB.self)!,
                scheduler: container.resolve(Scheduler.self)!,
                ibeaconsTracker: container.resolve(IbeaconsTracker.self)!)
            }.inObjectScope(.Container)
         container.resolve(TaskNotificationsTracker.self)

    }
    
}