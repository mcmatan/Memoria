
import Foundation
import UIKit

class Label : UILabel {
    
    func defaultyTitle() {
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = UIColor.black
    }
    
    func titleGray() {
        self.font = UIFont.systemFont(ofSize: 14)
        self.textColor = UIColor.gray
    }

}
