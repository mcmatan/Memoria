
import Foundation
import Swinject
import UIKit

public class AssemblyControllers {
    
    class func run(container : Container) {
        container.register(TabBarController.self) { c in
            let tabBar = TabBarController()
            guard let left = c.resolve(AddTasksLocationViewController.self) else {return tabBar}
            guard let  center = c.resolve(MemoriesViewController.self) else {return tabBar}
            guard let right = c.resolve(DrugsViewController.self) else {return tabBar}
//            let controllers = [left, center, right]
 
            let controllers = [left]
            tabBar.viewControllers = controllers
            left.tabBarItem = UITabBarItem(
                title: "Tasks",
                image: nil,
                tag: 1)
//            center.tabBarItem = UITabBarItem(
//                title: "Memories",
//                image: nil,
//                tag: 2)
//            right.tabBarItem = UITabBarItem(
//                title: "Drugs",
//                image: nil,
//                tag:3)
            tabBar.selectedIndex = 1
            return tabBar
        }
        
        container.register(NavigationController.self) { c in
            let navigationController = NavigationController(rootViewController : c.resolve(TabBarController)!)
            return navigationController
        }

        container.register(TasksNotificationsTracker.self) { c in
            return TasksNotificationsTracker(tasksServices: container.resolve(TasksServices.self)!,
                iBeaconServices:  container.resolve(IBeaconServices.self)!)
            }.inObjectScope(.Container)
        container.resolve(TasksNotificationsTracker.self)
        
    }
}