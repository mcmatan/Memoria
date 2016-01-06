
import Foundation
import RealmSwift

let uiRealm = try! Realm()

class TasksDataBase {
    
    func saveTask(task : Task) {
        do {
            try
            uiRealm.write({ () -> Void in
                uiRealm.add(task)
            })

        } catch {
            print("Task data base didnt manage to save task")
        }
    }
    
    func getTasks()-> [Task] {

        let list = uiRealm.objects(Task)
        return list.map { $0 }
        
    }
}