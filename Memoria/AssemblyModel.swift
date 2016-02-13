

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
            return TasksServices(tasksDB: container.resolve(TasksDB.self)!, reminder: container.resolve(ReminderSqueduler.self)!)
        }.inObjectScope(.Container)

        container.register(CurrenctTaskCreator.self) { c in
            return CurrenctTaskCreator()
            }.inObjectScope(.Container)

        container.register(ReminderSqueduler.self) { c in
            return ReminderSqueduler()
            }.inObjectScope(.Container)

        container.register(NearTaskMonitor.self) { c in
            return NearTaskMonitor(tasksDB: container.resolve(TasksDB.self)!)
            }.inObjectScope(.Container)
        container.resolve(NearTaskMonitor.self)

    }
    
}