

import Foundation
import Swinject

open class AssemblyMainApplicationUI {

    class func run(_ container : Container) {
        
        container.register(TaskManagerViewController.self) { _ in
            return TaskManagerViewController(tasksServices: container.resolve(TasksServices.self)!,currenctTaskCreator: container.resolve(CurrenctTaskCreator.self)!, container: container, iNearableServices: container.resolve(NearableServices.self)!)
        }
        
        container.register(AddTaskViewController.self) { _ in
            return AddTaskViewController(currentTaskCreator: container.resolve(CurrenctTaskCreator.self)!, taskServices: container.resolve(TasksServices.self)!)
        }
        
        container.register(TaskNotificationPopUp.self) { _, task in
            return TaskNotificationPopUp(task: task, tasksServices: container.resolve(TasksServices.self)!)
        }

        container.register(TaskVerificationPopUp.self) { _, task in
            return TaskVerificationPopUp(task: task)
        }

        container.register(TaskWarningPopUp.self) { _, task in
            return TaskWarningPopUp(task: task)
        }
        
        container.register(FeedViewController.self) { _ in
            return FeedViewController(taskServices: container.resolve(TasksServices.self)!)
        }
        
        container.register(NextTaskViewController.self) { _ in
            return NextTaskViewController(tesksService: container.resolve(TasksServices.self)!)
        }
        
        container.register(UINotificationActionsExecuter.self) { c in
            return UINotificationActionsExecuter(
                taskServices: container.resolve(TasksServices.self)!,
                tasksNotificationsPresenter: container.resolve(TasksNotificationsPresenter.self)!
            )
            }.inObjectScope(ObjectScope.container)
        
        container.register(TabBarController.self) { c in
            let tabBar = TabBarController()
            let taskManager = c.resolve(TaskManagerViewController.self)!
            let feed = c.resolve(FeedViewController.self)!
            let nextTesk = c.resolve(NextTaskViewController.self)!
            let controllers = [taskManager, feed, nextTesk]
            tabBar.viewControllers = controllers
            taskManager.tabBarItem = UITabBarItem(
                title: Content.getContent(ContentType.labelTxt, name: "TabBarTasksLbl"),
                image: UIImage(named: "TaskManagerLogoTab"),
                tag: 1)
            feed.tabBarItem = UITabBarItem(
                title: Content.getContent(ContentType.labelTxt, name: "TabBarFeedLbl"),
                image: UIImage(named: "feedIcon"),
                tag: 2)
            nextTesk.tabBarItem = UITabBarItem(
                title: Content.getContent(ContentType.labelTxt, name: "TabBarNextTaskLbl"),
                image: UIImage(named: "bell"),
                tag: 3)
            tabBar.selectedIndex = 1
            return tabBar
        }
        
        container.register(NavigationController.self) { c in
            let navigationController = NavigationController(rootViewController : c.resolve(TabBarController.self)!)
            return navigationController
        }.inObjectScope(ObjectScope.container)
        let _ = container.resolve(NavigationController.self)
        
        container.register(TasksNotificationsPresenter.self) { c in
            return TasksNotificationsPresenter(
                iNearableServices:  container.resolve(NearableServices.self)! ,
                container: container,
                notificationScheduler: container.resolve(NotificationScheduler.self)!,
                mainApplicationViewController : container.resolve(NavigationController.self)!
            )
            }.inObjectScope(ObjectScope.container)
        let _ = container.resolve(TasksNotificationsPresenter.self)

    }
}
