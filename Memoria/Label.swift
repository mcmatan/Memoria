
import Foundation
import UIKit

class Label : UILabel {
    
    func defaultyTitleLarge() {
        self.font =  UIFont.systemFont(ofSize: 22.0)
        self.textColor = UIColor.black
    }
    
    func defaultyTitle() {
        self.font =  UIFont.systemFont(ofSize: 19.0)
        self.textColor = UIColor.black
    }
    
    func defaultTitleGray() {
        self.defaultyTitle()
        self.textColor = UIColor(white: 0.6, alpha: 1)
    }
    
    func defaultySubtitle() {
        self.font = UIFont.systemFont(ofSize: 17.0)
        self.textColor = UIColor.gray
    }
    
    func defaultySubtitleGray() {
        self.defaultySubtitle()
        self.textColor = UIColor(white: 0.6, alpha: 1)
    }

}
