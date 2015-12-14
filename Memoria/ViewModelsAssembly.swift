
import Foundation
import Swinject

public class ViewModelsAssembly {

    class func run(container : Container) {
        container.register(MemoriesViewModel.self) { c in
            return MemoriesViewModel()
//            return FeedViewModel(flickerServices: c.resolve(FlickerServices.self)!, feedCellViewModelFactory: c.resolve(FeedCellViewModelFactory.self)!)
//        }

        }
    
    }

}