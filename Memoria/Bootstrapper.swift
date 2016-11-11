
import Foundation
import Swinject
class Bootstrapper {
    static var container = Container()

    class func run() {
        AssemblyModel.run(container)
        AssemblyUIComponents.run(container)
        
        let _ = container.resolve(UINotificationActionsExecuter.self)
        let _ = container.resolve(NearableStriggerManager.self)
        let _ = container.resolve(NearableLocator.self)
    
    }
    
}
