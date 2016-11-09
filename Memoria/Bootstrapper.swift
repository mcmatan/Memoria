
import Foundation
import Swinject
class Bootstrapper {
    static var container = Container()

    class func run() {
        AssemblyUIComponents.run(container)
        AssemblyModel.run(container)
        AssemblyControllers.run(container)
        
        let _ = container.resolve(UINotificationExecuter.self)
     
    }
    
}
