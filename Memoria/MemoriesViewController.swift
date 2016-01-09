
import Foundation
import UIKit

class MemoriesViewController : ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remindMe = Button()
        remindMe.defaultStyle()
        remindMe.setTitle(Content.getContent(ContentType.ButtonTxt, name: "RemindMeWhereIAm"), forState: UIControlState.Normal)
        self.view.addSubview(remindMe)
        remindMe.centerInSuperView()
    }
}