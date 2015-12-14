
import Foundation
import UIKit

class ViewController : UIViewController {
    let defaultBackgroundColor = UIColor.whiteColor()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = defaultBackgroundColor
    }
}
