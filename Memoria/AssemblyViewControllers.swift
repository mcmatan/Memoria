

import Foundation
import Swinject

public class AssemblyViewControllers {

    class func run(container : Container) {
        container.register(MemoriesViewController.self) { c in
            return MemoriesViewController()
        }
        container.register(AddTasksLocationViewController.self) { _ in
            let currentTaskCreator = container.resolve(CurrenctTaskCreator.self)!
            currentTaskCreator.startNewTask()
            return AddTasksLocationViewController(container: container, tasksServices: container.resolve(TasksServices.self)!, iBeaconServices: container.resolve(IBeaconServices.self)!, currenctTaskCreator: currentTaskCreator)
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
        
        container.register(AddTaskNameViewController.self) { _ in
            return AddTaskNameViewController(container: container, currenctTaskCreator: container.resolve(CurrenctTaskCreator.self)!)
        }

        container.register(AddTaskVoiceViewController.self) { _ in
            return AddTaskVoiceViewController(container: container, currenctTaskCreator: container.resolve(CurrenctTaskCreator.self)!)
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
        
        container.register(TaskNotificationPopUp.self) { _, task in
            return TaskNotificationPopUp(task: task)
        }
        
        container.resolve(TaskNotificationPopUp.self, argument: Task(taskName: "", taskTime: NSDate(), taskVoiceURL: NSURL(), taskBeaconIdentifier: IBeaconIdentifier(uuid: "", major: "", minor: ""), taskTimePriorityHi: true))

        container.register(TaskVerificationPopUp.self) { _, task in
            return TaskVerificationPopUp(task: task, tasksServices: container.resolve(TasksServices.self)!)
        }

        container.register(TaskWarningPopUp.self) { _, task in
            return TaskWarningPopUp(task: task)
        }



    }
}