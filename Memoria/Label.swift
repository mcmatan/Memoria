
import Foundation
import UIKit

class Label : UILabel {
    
    func defaultyTitle() {
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = UIColor.black
    }
    
    func defaultyLargeTitle() {
        self.font = UIFont.systemFont(ofSize: 20)
        self.textColor = UIColor.black
    }
    
    func defaultySubtitle() {
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = UIColor.gray
    }
    
    func titleGray() {
        self.font = UIFont.systemFont(ofSize: 14)
        self.textColor = UIColor.gray
    }

}
