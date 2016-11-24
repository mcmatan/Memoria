
import Foundation

struct NotificationText {
    let title: String
    let body: String
}


class NotificationsTextsBuilder {
    
    static func getNotificationText(task: Task)->NotificationText {
        switch task.taskType {
        case TaskType.brushTeeth:
            return self.bruthTeeth()
        case TaskType.drugs:
            return self.drugs()
        case TaskType.food:
            return self.food()
        case TaskType.wakeUp:
            return self.wakeUp()
        case TaskType.goToWork:
            return self.goToWork()
        case TaskType.goToGym:
            return self.goToGym()
            
        }
    }
        
    static func bruthTeeth()->NotificationText {
        let title = "Time to brush your teeth"
        let body = "And have a great day (:"
        return NotificationText(title: title, body: body)
    }

    static func drugs()->NotificationText {
        let title = "Time to go and take your pills."
        let body = "Hope your having a great day"
        return NotificationText(title: title, body: body)
    }

    static func food()->NotificationText {
        let title = "Time to make dinner."
        let body = "Bon Appetit (:"
        return NotificationText(title: title, body: body)
    }
    
    static func wakeUp()->NotificationText {
        let title = "Time to wake up!"
        let body = "Rise and shine (:"
        return NotificationText(title: title, body: body)
    }

    static func goToWork()->NotificationText {
        let title = "Time to go to work"
        let body = "Hope you have successful day (:"
        return NotificationText(title: title, body: body)
    }
    
    static func goToGym()->NotificationText {
        let title = "Time to go to the gym"
        let body = "Work hard play hard"
        return NotificationText(title: title, body: body)
    }

}
