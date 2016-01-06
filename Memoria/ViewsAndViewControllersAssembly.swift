

import Foundation
import Swinject

public class ViewsAndViewControllersAssembly {

    class func run(container : Container) {
        container.register(MemoriesViewController.self) { c in
            MemoriesViewController()
        }
        container.register(TasksViewController.self) { c in
            TasksViewController(container: container)
        }
        container.register(MemoriesViewController.self) { c in
             MemoriesViewController()
        }
        container.register(DrugsViewController.self) { c in
            DrugsViewController()
        }
        
        container.register(AddTaskTimeViewController.self) { _, name in
            AddTaskTimeViewController(taskName: name , container:  container)
        }
        
        container.register(AddTaskNameViewController.self) { c in
            AddTaskNameViewController(container: container)
        }

        container.register(AddTaskVoiceViewController.self) { _, name, tasksDates in
            AddTaskVoiceViewController(container: container, taskName: name, tasksDates: tasksDates)
        }

    }
}