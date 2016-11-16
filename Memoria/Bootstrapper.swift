
import Foundation
import Swinject
class Bootstrapper {
    static var container = Container()

    class func runLogin() {
        AssemblyLogin.run(container)
        ServiceLocator.container = container
        self.setServiceLocator()
    }
    
    class func runMainApplication() {
        AssemblyMainApplicationModel.run(container)
        AssemblyMainApplicationUI.run(container)
        let _ = container.resolve(UINotificationActionsExecuter.self)
        let _ = container.resolve(NearableStriggerManager.self)
        let _ = container.resolve(NearableLocator.self)
        self.setServiceLocator()
    }
    
    class func setServiceLocator() {
        ServiceLocator.container = container
    }
    
}
