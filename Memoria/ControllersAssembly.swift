
import Foundation
import Swinject
import UIKit

public class ControllersAssembly {
    
    class func run(container : Container) {
        container.register(TabBarController.self) { c in
            let tabBar = TabBarController()
            let left = TasksViewController()
            let center = MemoriesViewController()
            let right = DrugsViewController()
            let controllers = [left, center, right]
            tabBar.viewControllers = controllers
            left.tabBarItem = UITabBarItem(
                title: "Tasks",
                image: nil,
                tag: 1)
            center.tabBarItem = UITabBarItem(
                title: "Memories",
                image: nil,
                tag: 2)
            right.tabBarItem = UITabBarItem(
                title: "Drugs",
                image: nil,
                tag:3)
            tabBar.selectedIndex = 1
            return tabBar
        }
        
    }
}