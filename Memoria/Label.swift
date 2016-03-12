
import Foundation
import UIKit

class Label : UILabel {
    
    func defaultyTitle() {
        self.font = UIFont.systemFontOfSize(16)
        self.textColor = UIColor.blackColor()
    }
    
    func titleGray() {
        self.font = UIFont.systemFontOfSize(14)
        self.textColor = UIColor.grayColor()
    }

}
