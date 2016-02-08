
import Foundation
import Swinject
class Bootstrapper {
    static var container = Container()

    class func run() {
        AssemblyViewControllers.run(container)
        AssemblyModel.run(container)
        AssemblyControllers.run(container)        
     
    }
    
}
