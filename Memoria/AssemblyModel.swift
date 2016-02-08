

import Foundation
import Swinject

public class AssemblyModel {
    
    class func run(container : Container) {
        container.register(IbeaconLocationFinder.self) { c in
            let ibeaconLocationFinder = IbeaconLocationFinder()
            return ibeaconLocationFinder
        }.inObjectScope(.Container)

        container.register(TasksDB.self) { c in
            return TasksDB()
        }.inObjectScope(.Container)

        container.register(TasksNotificationsTracker.self) { c in
            return TasksNotificationsTracker(tasksDB: container.resolve(TasksDB.self)!)
        }.inObjectScope(.Container)

        container.register(IBeaconServices.self) { c in
            return IBeaconServices(ibeaconLocationFinder: container.resolve(IbeaconLocationFinder.self)!, tasksDB:
            container.resolve(TasksDB.self)!)
        }.inObjectScope(.Container)

        container.register(TasksServices.self) { c in
            return TasksServices(tasksDB: container.resolve(TasksDB.self)!, reminder: container.resolve(Reminder.self)!)
        }.inObjectScope(.Container)

        container.register(CurrenctTaskCreator.self) { c in
            return CurrenctTaskCreator()
            }.inObjectScope(.Container)

        container.register(Reminder.self) { c in
            return Reminder()
            }.inObjectScope(.Container)
        
    }
    
}