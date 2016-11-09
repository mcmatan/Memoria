

import Foundation
import Swinject

open class AssemblyUIComponents {

    class func run(_ container : Container) {
        container.register(MemoriesViewController.self) { c in
            return MemoriesViewController()
        }
        
        container.register(MemoriesViewController.self) { c in
             return MemoriesViewController()
        }
        
        container.register(DrugsViewController.self) { c in
            return DrugsViewController()
        }
        
        container.register(AddTaskTimeViewController.self) { _   in
            return AddTaskTimeViewController(container: container, currenctTaskCreator: container.resolve(CurrenctTaskCreator.self)!)
        }

        container.register(AddTaskConfirmationViewController.self) { _  in
            let currentTaskCreator = container.resolve(CurrenctTaskCreator.self)
            return AddTaskConfirmationViewController(container: container, tasksServices: container.resolve(TasksServices.self)!, currenctTaskCreator: currentTaskCreator!)
        }

        container.register(TaskManagerViewController.self) { _ in
            return TaskManagerViewController(tasksServices: container.resolve(TasksServices.self)!,currenctTaskCreator: container.resolve(CurrenctTaskCreator.self)!, container: container, iBeaconServices: container.resolve(IBeaconServices.self)!)
        }
        container.register(AddTaskTimePriorityController.self) { _ in
            return AddTaskTimePriorityController(container: container,
                currenctTaskCreator: container.resolve(CurrenctTaskCreator.self)!, tasksServices: container.resolve(TasksServices.self)!)
        }
        
        container.register(AddTaskTypeViewController.self) { _ in
            return AddTaskTypeViewController(container: container, currenctTaskCreator: container.resolve(CurrenctTaskCreator.self)!)
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
        
        container.register(UINotificationExecuter.self) { c in
            return UINotificationExecuter(
                taskServices: container.resolve(TasksServices.self)!,
                tasksNotificationsPresenter: container.resolve(TasksNotificationsPresenter.self)!
            )
            }.inObjectScope(ObjectScope.container)

    }
}