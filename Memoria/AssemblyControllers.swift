
import Foundation
import Swinject
import UIKit

public class AssemblyControllers {
    
    class func run(container : Container) {
        container.register(TabBarController.self) { c in
            let tabBar = TabBarController()
            guard let left = c.resolve(ManageAddTasksLocationViewController.self) else {return tabBar}
            guard let  _ = c.resolve(MemoriesViewController.self) else {return tabBar}
            guard let _ = c.resolve(DrugsViewController.self) else {return tabBar}
//            let controllers = [left, center, right]
 
            let controllers = [left]
            tabBar.viewControllers = controllers
            left.tabBarItem = UITabBarItem(
                title: "Tasks",
                image: UIImage(named: "TasksManagerLogoTabOnlyImage"),
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

        container.register(TasksNotificationsPresenter.self) { c in
            return TasksNotificationsPresenter(tasksServices: container.resolve(TasksServices.self)!,
                iBeaconServices:  container.resolve(IBeaconServices.self)!)
            }.inObjectScope(.Container)
        container.resolve(TasksNotificationsPresenter.self)
        
    }
}