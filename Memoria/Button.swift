
import Foundation
import UIKit
import SnapKit

class Button : UIButton {
    var defaultWidth = UIScreen.mainScreen().bounds.size.width - 80
    var defaultHeight = 100
    
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
        self.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(defaultWidth)
            make.height.equalTo(defaultHeight)
        }
    }
    
    func defaultColor() {
        self.backgroundColor = UIColor.orangeColor()
    }
    
    func defaultCornerRaduis() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 3.0
    }
    
}