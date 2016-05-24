
import Foundation
import UIKit

class TabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Content.getContent(ContentType.LabelTxt, name: "TaskManagerTitle")
     
        let image = UIImage(named: "navigationBar")
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
    }
}
