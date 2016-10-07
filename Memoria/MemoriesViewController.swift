
import Foundation
import UIKit

class MemoriesViewController : ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remindMe = Button()
        remindMe.defaultStyle()
        remindMe.setTitle(Content.getContent(ContentType.buttonTxt, name: "RemindMeWhereIAm"), for: UIControlState())
        self.view.addSubview(remindMe)
        remindMe.centerInSuperView()
    }
}
