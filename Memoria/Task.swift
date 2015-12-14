
import Foundation

class Task {
    var name : String
    var times : [NSDate]
    
    init(name : String, times : [NSDate]) {
        self.name = name
        self.times = times
    }
}
