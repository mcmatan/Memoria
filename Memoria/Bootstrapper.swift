
import Foundation
import Swinject
class Bootstrapper {
    static var container = Container()

    class func run() {
        ViewsAndViewControllersAssembly.run(container)
        ServicesAssembly.run(container)
        FactorysAssembly.run(container)
        ControllersAssembly.run(container)
    }
    
}
