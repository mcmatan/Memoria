
import Foundation
import UIKit

class MemoriesViewController : ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remindMe = Button()
        remindMe.defaultStyle()
        remindMe.setTitle(Content.getContent(ContentType.ButtonTxt, name: "RemindMeWhereIAm"), forState: UIControlState.Normal)
        self.view.addSubview(remindMe)
        remindMe.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp_centerX)
            make.centerY.equalTo(self.view.snp_centerYWithinMargins)
        }
        
    }
}