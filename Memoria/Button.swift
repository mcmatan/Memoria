
import Foundation
import UIKit
import SnapKit

class Button : UIButton {
    var myDefaultWidth = Double(UIScreen.mainScreen().bounds.size.width) - 80.0
    var myDefaultHeight = 70.0
    
    init() {
        super.init(frame: CGRectZero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func defaultStyle() {
        self.defaultSize()
        self.defaultColor()
        self.defaultCornerRaduis()
    }
    
    func defaultSize() {
        self.defaultHeight()
        self.defaultWidth()
    }
    
    func defaultHeight() {
        self.heightLayoutAs(myDefaultHeight)
    }
    
    func defaultWidth() {
        self.widthLayoutAs(myDefaultWidth)
    }
    
    func defaultColor() {
        self.backgroundColor = UIColor.orangeColor()
    }
    
    func defaultCornerRaduis() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 3.0
    }
    
}