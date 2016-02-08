
import Foundation
import UIKit
import SnapKit

class Button : UIButton {
    var myDefaultWidth = Double(UIScreen.mainScreen().bounds.size.width) - 80.0
    var myDefaultHeight = 70.0
    
    var colorFlicker = UIColor.redColor()
    var flickerTimer : NSTimer?
    
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
    
    func defaultStyleMini() {
        self.titleLabel?.font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        self.defaultColor()
        self.defaultCornerRaduis()
        self.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
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
    
    deinit {
        if let _ = self.flickerTimer {
            self.stopFlickerRedColor()
        }
    }
    
    
    //MARK : color flicker
    func startFlickeringRedColor() {
        self.flickerTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("tickRedColor"), userInfo: nil, repeats: true)
    }
    
    func stopFlickerRedColor() {
        if let _ = self.flickerTimer {
            self.flickerTimer!.invalidate()
            self.flickerTimer = nil
        }
    }
    
    func tickRedColor() {
        if (self.backgroundColor == UIColor.redColor()) {
            self.defaultColor()
        } else { self.backgroundColor = UIColor.redColor() }
    }
}