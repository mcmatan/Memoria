

import Foundation
import Swinject

public class ViewsAndViewControllersAssembly {

    class func run(container : Container) {
        container.register(MemoriesViewController.self) { c in
          return MemoriesViewController()
        }
//        container.register(FeedViewController.self) { c in
//            let feedViewController = FeedViewController()
//            feedViewController.setViewModel(c.resolve(IFeedViewModel.self)!)
//            return feedViewController
//        }

    }
}